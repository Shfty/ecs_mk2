extends Node
tool

var root_node: Node = null setget set_root_node

""" TraitQuery constructor """
static func query(name: String, traits: Array) -> TraitQuery:
	var query = TraitQuery.new()
	query.set_name(name)
	query.traits = traits
	return query

""" Setters """
func set_root_node(new_root_node: Node) -> void:
	if root_node != new_root_node:
		if root_node != null:
			clear_descendants(root_node)

		root_node = new_root_node

		if root_node != null:
			update_descendants(root_node)

""" Getters """
func get_traits() -> Array:
	var traits := []
	for trait_path in ProjectSettings.get_setting("traitor/traitor/traits"):
		if ResourceLoader.exists(trait_path):
			var trait_script = load(trait_path)
			if trait_script:
				traits.append(trait_script)
		else:
			printerr("Traitor Error: Trait script at %s does not exist" % trait_path)
	return traits

""" Lifecycle """
func _enter_tree() -> void:
	var tree = get_tree()
	tree.connect("node_added", self, "on_node_added")
	tree.connect("node_removed", self, "on_node_removed")

func _ready() -> void:
	if not Engine.is_editor_hint() and root_node == null:
		root_node = get_tree().get_root()

	if root_node != null:
		update_descendants(root_node)

func _exit_tree() -> void:
	get_tree().disconnect("node_added", self, "on_node_added")
	get_tree().disconnect("node_removed", self, "on_node_removed")

""" Returns true if the provided node is inside the root """
func is_inside_root(node: Node) -> bool:
	if not root_node:
		return false

	var candidate = node
	while true:
		if not candidate:
			break

		if candidate == root_node:
			return true

		candidate = candidate.get_parent()

	return false

""" SceneTree::node_added callback """
func on_node_added(node: Node) -> void:
	# Ignore nodes outside the root
	if not is_inside_root(node):
		return

	update_node(node)
	update_ancestors(node)

""" SceneTree::node_removed callback """
func on_node_removed(node: Node) -> void:
	# Ignore nodes outside the root
	if not is_inside_root(node):
		return

	node.set_meta("is_queued_for_remove", true)

	clear_node(node)
	update_ancestors(node)

	node.remove_meta("is_queued_for_remove")

""" Remove node from all interface groups """
func clear_node(node: Node) -> void:
	for trait in get_traits():
		if not trait:
			continue

		var group_name = Trait.group_name(trait)
		if node.is_in_group(group_name):
			node.remove_from_group(group_name)
	node.update_configuration_warning()

""" Clear all nodes from the root down """
func clear_descendants(node: Node) -> void:
	clear_node(node)

	for child in node.get_children():
		clear_descendants(child)

""" Check node against all interfaces and add / remove from groups as appropriate """
func update_node(node: Node) -> void:
	for trait in get_traits():
		if not trait:
			continue

		var group_name = Trait.group_name(trait)
		var is_implementor = trait.is_implementor(node)

		if node.is_in_group(group_name):
			if not is_implementor:
				node.remove_from_group(group_name)
				node.update_configuration_warning()
		else:
			if is_implementor:
				node.add_to_group(group_name, true)
				node.update_configuration_warning()

""" Update all nodes from the root down """
func update_descendants(node: Node) -> void:
	update_node(node)

	for child in node.get_children():
		update_descendants(child)

""" Update all nodes from the provided one to the root """
func update_ancestors(node: Node) -> void:
	var candidate = node.get_parent()
	while true:
		if not candidate:
			break

		if candidate == root_node:
			break

		update_node(candidate)
		candidate = candidate.get_parent()
