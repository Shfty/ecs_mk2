extends Tree
tool

enum Mode {
	Entities,
	Queries
}

export(Mode) var mode := Mode.Entities setget set_mode

func set_mode(new_mode: int) -> void:
	if mode != new_mode:
		mode = new_mode
		if is_inside_tree():
			rebuild()

func _init() -> void:
	hide_root = true

func _enter_tree() -> void:
	Traitor.connect("queries_updated", self, "rebuild")
	rebuild()

func _exit_tree() -> void:
	Traitor.disconnect("queries_updated", self, "rebuild")

func _process(delta: float) -> void:
	update()

func rebuild() -> void:
	clear()

	var root = create_item()

	match mode:
		Mode.Entities:
			entity_columns()
			entity_header(root)
			entity_rows(root)
		Mode.Queries:
			query_columns()
			query_items(root)

func query_columns() -> void:
	var count := 0
	for query in Traitor.queries:
		count = max(count, 2 + query.params.size())
	columns = count

	set_column_expand(0, false)
	set_column_min_width(0, 64)

func query_items(parent: TreeItem) -> void:
	for query in Traitor.queries:
		var item = query_item(parent, query)
		query_header_item(item, query)
		query_result_items(item, query)

func query_item(parent: TreeItem, query: Query) -> TreeItem:
	var item = create_item(parent)
	item.set_text(0, query.name)
	return item

func query_header_item(parent: TreeItem, query: Query) -> TreeItem:
	var item = create_item(parent)
	item.set_text(0, "ID")
	item.set_text(1, "Name")

	var i = 0
	for param in query.params:
		item.set_text(2 + i, param.trait.new()._name())
		i += 1

	return item

func query_result_items(parent: TreeItem, query: Query) -> void:
	var results = Traitor.QueryHandle.new(query).run()
	for node in results:
		var result = results[node]
		var item = create_item(parent)

		var id_trait = Trait.lift(node, ID)
		var name_trait = Trait.lift(node, Name)

		set_item_custom(item, 0, "draw_result_cell", id_trait)
		set_item_custom(item, 1, "draw_result_cell", name_trait)

		var i = 0
		for param in query.params:
			var trait = result[param.trait]
			set_item_custom(item, 2 + i, "draw_result_cell", trait)
			i += 1

func set_item_custom(item: TreeItem, column: int, callback: String, metadata) -> void:
	item.set_cell_mode(column, TreeItem.CELL_MODE_CUSTOM)
	item.set_custom_draw(column, self, callback)
	item.set_metadata(column, metadata)

func draw_result_cell(item: TreeItem, rect: Rect2) -> void:
	var column = get_column_at_position(rect.position + rect.size - Vector2.ONE)
	if column < 0:
		column = get_column_at_position(rect.position + Vector2.ONE)
	if column < 0:
		return

	var trait = item.get_metadata(column)
	var data = get_trait_data(trait)

	var font = get_font("")
	var string = "%s" % [data]
	var size = font.get_string_size(string)
	draw_string(font, rect.position + Vector2(0, size.y), string, Color.white, rect.size.x)


func entity_columns() -> void:
	columns = 2 + Traitor.traits.size()
	set_column_expand(0, false)
	set_column_min_width(0, 64)

func entity_header(parent: TreeItem) -> void:
	var item = create_item(parent)
	item.set_text(0, "ID")
	item.set_text(1, "Name")

	for i in range(0, Traitor.traits.size()):
		item.set_text(2 + i, Traitor.traits[i].new()._name())

func entity_rows(parent: TreeItem) -> void:
	for node in Traitor._get_nodes():
		var item = create_item(parent)

		var id_trait = Trait.lift(node, ID)
		var name_trait = Trait.lift(node, Name)

		set_item_custom(item, 0, "draw_result_cell", id_trait)
		set_item_custom(item, 1, "draw_result_cell", name_trait)

		for i in range(0, Traitor.traits.size()):
			var trait = Trait.lift(node, Traitor.traits[i])
			var data = "[None]"
			if trait:
				set_item_custom(item, 2 + i, "draw_result_cell", trait)
			else:
				item.set_text(2 + i, "%s" % [data])

func get_trait_data(trait: Trait):
	if trait:
		if trait is PropertyTrait:
			return trait.get_property()
		elif trait is SetGetTrait:
			return trait.get_property()
		elif trait is MethodTrait:
			return trait.call_method()
		elif trait is ComponentTrait:
			return trait.get_component()
		else:
			return trait._name()
