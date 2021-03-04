class_name QueryOptions
extends OptionButton
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

	connect("item_selected", self, "on_item_selected")

func rebuild() -> void:
	clear()

	var system = get_node_or_null(system_path)
	if not system:
		return

	var queries = Queries.get_queries(system)
	for query in queries:
		add_item(query.get_name())
	on_item_selected(0)

func on_item_selected(index: int) -> void:
	var system = get_node(system_path)
	var queries = Queries.get_queries(system)
	emit_signal("query_selected", queries[index])
