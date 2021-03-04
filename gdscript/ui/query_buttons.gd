class_name QueryButtons
extends VBoxContainer
tool

signal query_selected(query)

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
		if child.has_meta("query_buttons_child"):
			remove_child(child)
			child.queue_free()

	var system = get_node_or_null(system_path)
	if not system:
		return

	var queries = Queries.get_queries(system)
	var button_group = ButtonGroup.new()
	for i in range(0, queries.size()):
		var query = queries[i]
		var button = Button.new()
		button.text = query.get_name()
		button.size_flags_horizontal = SIZE_EXPAND_FILL
		button.toggle_mode = true
		button.group = button_group
		button.connect("pressed", self, "on_item_selected", [i])
		button.set_meta("query_buttons_child", true)
		add_child(button)
	on_item_selected(0)
	get_child(0).pressed = true

func on_item_selected(index: int) -> void:
	var system = get_node(system_path)
	var queries = Queries.get_queries(system)
	emit_signal("query_selected", queries[index])
