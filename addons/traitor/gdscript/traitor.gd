"""
Traitor Singleton

Manages object grouping and query acceleration structure
"""

extends Node
tool

signal queries_updated()

const DEBUG := false

"""
Path to the scene root
Defaults to the tree root at runtime, and the edited scene root in the editor
"""
var root_path := NodePath()

""" Cached traits """
var traits := []

""" Cached systems (trait owners) """
var systems := []

""" Cached queries """
var queries := []

""" Cached query results """
var results := {}

""" Opaque handle that can be used to invoke a query via the acceleration structure """
class QueryHandle:
	var _query_ref: WeakRef

	func _init(query: Query) -> void:
		_query_ref = weakref(query)

	func run() -> Dictionary:
		return Traitor._run_query(_query_ref.get_ref())

""" Set the root path to the provided node """
func set_root(new_root: Node) -> void:
	if DEBUG:
		print_debug("set_root: %s" % [new_root])

	if not new_root:
		root_path = NodePath()
		return

	var new_path = get_path_to(new_root)
	if root_path != new_path:
		root_path = new_path
		if is_inside_tree():
			_update()

""" Retrieve the node from the root path """
func get_root() -> Node:
	return get_node_or_null(root_path)

func _enter_tree() -> void:
	if DEBUG:
		print_debug("_enter_tree")

	var tree = get_tree()

	# Default to the tree root if running outside of the editor
	if not Engine.is_editor_hint():
		root_path = get_path_to(tree.get_root())
		_update()

	# Connect node lifecycle signals
	tree.connect("node_added", self, "_on_node_added")
	tree.connect("node_removed", self, "_on_node_removed")

func _exit_tree() -> void:
	var tree = get_tree()

	# Disconnect node lifecycle signals
	tree.disconnect("node_added", self, "_on_node_added")
	tree.disconnect("node_removed", self, "_on_node_removed")

	_clear()

func _on_node_added(node: Node) -> void:

	var root = get_root()
	if not root:
		return

	if not root.is_a_parent_of(node):
		return

	if DEBUG:
		print_debug("_on_node_added: %s" % [node])

	update_groups_to_root(node)

	_update()

func _on_node_removed(node: Node) -> void:
	var root = get_root()
	if not root:
		return

	if not root.is_a_parent_of(node):
		return

	if DEBUG:
		print_debug("_on_node_removed: %s" % [node])

	node.set_meta("is_pending_remove", true)
	update_groups_to_root(node.get_parent())
	clear_groups(node)
	node.remove_meta("is_pending_remove")

	_update()

func update_groups_to_root(node: Node) -> void:
	var root = get_root()

	var candidate = node
	while true:
		update_groups(candidate)

		if candidate == null:
			return
		if candidate == root:
			return
		candidate = candidate.get_parent()

func update_groups(node: Node) -> void:
	for trait in traits:
		var to = trait.new()
		var group_name = to._group_name()
		if Trait.lift(node, trait):
			if not node.is_in_group(group_name):
				if DEBUG:
					print_debug("Adding %s to group %s" % [node.get_name(), group_name])
				node.add_to_group(group_name)
		else:
			if node.is_in_group(group_name):
				if DEBUG:
					print_debug("Removing %s from group %s" % [node.get_name(), group_name])
				node.remove_from_group(group_name)

func clear_groups(node: Node) -> void:
	for trait in traits:
		var to = trait.new()
		var group_name = to._group_name()
		if node.is_in_group(group_name):
			if DEBUG:
				print_debug("Removing %s from group %s" % [node.get_name(), group_name])
			node.remove_from_group(group_name)

""" Reset cached results """
func _clear() -> void:
	if DEBUG:
		print_debug("_clear")
	results.clear()

""" Rerun queries and cache results """
func _update() -> void:
	if DEBUG:
		print_debug("_update")
	_clear()

	var root = get_root()
	if not root:
		return

	for query in queries:
		var nodes = _get_query_nodes(query)
		results[query] = query.run(nodes)

	call_deferred("emit_signal", "queries_updated")

""" Fetch the cached result of the provided query from the acceleration structure """
func _run_query(query: Query) -> Dictionary:
	if DEBUG:
		print_debug("_run_query")
	if query in results:
		return results[query]
	else:
		return {}

""" Retrieve nodes that implement any of the traits inside of the provided query """
func _get_query_nodes(query: Query) -> Array:
	var nodes := []

	for param in query.params:
		var trait = param.trait
		var to = trait.new()
		var group_name = to._group_name()
		for node in get_tree().get_nodes_in_group(group_name):
			if not node in nodes:
				nodes.append(node)

	return nodes

""" Retrieve all known nodes """
func _get_nodes() -> Array:
	var nodes := []

	for trait in traits:
		var to = trait.new()
		var group_name = to._group_name()
		for node in get_tree().get_nodes_in_group(group_name):
			if not node in nodes:
				nodes.append(node)

	return nodes

""" Returns true if candidate_ancestor is an ancestor of node """
func _is_ancestor_of(node: Node, candidate_ancestor: Node) -> bool:
	if DEBUG:
		print_debug("_is_ancestor_of: %s, %s" % [node, candidate_ancestor])
	var candidate = node
	while true:
		if candidate == candidate_ancestor:
			return true
		if not candidate:
			return false
		candidate = candidate.get_parent()
	return false

""" Register a query with the acceleration structure and return a handle to it """
func query(owner: Node, name: String, params: Array) -> QueryHandle:
	if DEBUG:
		print_debug("query: %s" % [name, params])

	for param in params:
		var trait = param.trait
		if not trait in traits:
			traits.append(trait)

	if not owner in systems:
		systems.append(owner)

	var query = Query.new(owner, name, params)
	queries.append(query)
	if is_inside_tree():
		_update()
	return QueryHandle.new(query)
