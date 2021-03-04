class_name TraitorDebugger
extends Tree
tool

enum Mode {
	Systems,
	Query
}

export(Mode) var mode := Mode.Systems setget set_mode

var systems_query := Traitor.query("Systems Query", [Systems])
var custom_query: TraitQuery = null

func set_mode(new_mode: int) -> void:
	if mode != new_mode:
		mode = new_mode
		if is_inside_tree():
			rebuild()

func _init() -> void:
	hide_root = true
	columns = 3
	custom_query = TraitQuery.new()

func set_query_trait(trait: Script, enabled: bool) -> void:
	if enabled:
		if not trait in custom_query.traits:
			custom_query.traits.append(trait)
	else:
		if trait in custom_query.traits:
			custom_query.traits.erase(trait)

	if mode == Mode.Query:
		rebuild()

func _ready() -> void:
	rebuild()

func _process(delta: float) -> void:
	update()

func rebuild() -> void:
	clear()
	match mode:
		Mode.Systems:
			rebuild_systems()
		Mode.Query:
			rebuild_query()

func rebuild_systems() -> void:
	var systems_nodes = systems_query.run(get_tree())

	var systems := []
	for systems_node in systems_nodes:
		systems += systems_node.get_children()

	columns = system_column_count(systems)

	var root = create_item()
	for system in systems:
		system_item(root, system)

func rebuild_query() -> void:
	var root = create_item()

	columns = query_column_count(custom_query)

	query_header_item(root, custom_query)
	query_result_items(root, custom_query)

func system_column_count(systems: Array) -> int:
	var count = 0
	for system in systems:
		var queries = Queries.get_queries(system)
		for query in queries:
			count = max(count, query_column_count(query))
	return count

func query_column_count(query: TraitQuery) -> int:
	return 1 + query.traits.size()

func system_item(parent: TreeItem, system: System) -> TreeItem:
	var system_item := create_item(parent)
	system_item.set_text(0, system.get_name())
	system_query_items(system_item, system)
	return system_item

func system_query_items(parent: TreeItem, system: System) -> void:
	var queries = Queries.get_queries(system)
	for query in queries:
		query_item(parent, query)

func query_item(parent: TreeItem, query: TraitQuery) -> TreeItem:
	var query_item = create_item(parent)
	query_item.set_text(0, query.get_name())

	query_header_item(query_item, query)
	query_result_items(query_item, query)
	return query_item

func query_header_item(parent: TreeItem, query: TraitQuery) -> TreeItem:
	var result_header = create_item(parent)
	result_header.set_text(0, "Node")

	for i in range(0, query.traits.size()):
		var trait = query.traits[i]
		result_header.set_text(1 + i, trait.name())
	return result_header

func query_result_items(parent: TreeItem, query: TraitQuery) -> void:
	var nodes = query.run(get_tree())
	for node in nodes:
		var result_item = create_item(parent)
		result_cell(result_item, 0, Name, node)

		for i in range(0, query.traits.size()):
			var trait = query.traits[i]
			result_cell(result_item, i + 1, trait, node)

func result_cell(item: TreeItem, column: int, trait: Script, node: Node) -> void:
	item.set_metadata(column, [funcref(trait, "debug_string"), weakref(node)])
	item.set_cell_mode(column, TreeItem.CELL_MODE_CUSTOM)
	item.set_custom_draw(column, self, "draw_result_cell")

func draw_result_cell(tree_item: TreeItem, rect: Rect2) -> void:
	var font = get_font("", "")

	var column = get_column_at_position(rect.position + rect.size - Vector2.ONE)
	if column < 0:
		column = get_column_at_position(rect.position + Vector2.ONE)

	var data = tree_item.get_metadata(column)
	var debug_func = data[0]
	var debug_node = data[1].get_ref()

	var string = debug_func.call_func(debug_node)
	var size = font.get_string_size(string)
	draw_string(font, rect.position + Vector2(0, size.y), string, Color.white, rect.size.x)
