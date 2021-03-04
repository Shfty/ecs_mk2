class_name SystemQueries
extends VBoxContainer
tool

export(NodePath) var system_path setget set_system_path

func set_system_path(new_system_path: NodePath) -> void:
	if system_path != new_system_path:
		system_path = new_system_path
		if is_inside_tree():
			rebuild()

func set_system(new_system: System) -> void:
	set_system_path(get_path_to(new_system))

func _enter_tree() -> void:
	rebuild()

func rebuild() -> void:
	for child in get_children():
		if child.has_meta("queries_child"):
			remove_child(child)
			child.queue_free()

	var system = get_node_or_null(system_path)
	if not system:
		return

	var queries = Queries.get_queries(system)
	var button_group = ButtonGroup.new()
	for i in range(0, queries.size()):
		var query = queries[i]

		var label = Label.new()
		label.text = query.get_name()
		label.set_meta("queries_child", true)
		add_child(label)

		var debugger = QueryDebugger.new()
		debugger.size_flags_horizontal = SIZE_EXPAND_FILL
		debugger.set_query(query)
		debugger.set_meta("queries_child", true)
		add_child(debugger)
