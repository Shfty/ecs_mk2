class_name QueryDebugger
extends Tree
tool

export(Resource) var query: Resource = null setget set_query

var _root: TreeItem = null

func set_query(new_query: Resource) -> void:
	if not new_query is TraitQuery:
		new_query = null

	if query != new_query:
		query = new_query

		if is_inside_tree():
			rebuild()

func _init() -> void:
	hide_root = true

func _enter_tree() -> void:
	rebuild()

func _process(delta: float) -> void:
	rebuild()

func rebuild() -> void:
	clear()
	_root = null

	var height := 0
	if query:
		_root = create_item()
		set_columns(query.traits.size() + 1)

		var header = create_item(_root)

		header.set_text(0, "Node")
		for i in range(0, query.traits.size()):
			var trait = query.traits[i]
			header.set_text(i + 1, trait.name())
			i += 1

		for node in query.run(get_tree()):
			var item = create_item(_root)
			item.set_text(0, node.get_name())
			for i in range(0, query.traits.size()):
				var trait = query.traits[i]
				item.set_text(i + 1, trait.debug_string(node))
				height += get_item_area_rect(item).size.y
	else:
		set_columns(1)
		set_column_title(0, "")

	rect_min_size.y = height + 32
	rect_size.y = rect_min_size.y

	property_list_changed_notify()
