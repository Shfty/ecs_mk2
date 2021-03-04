class_name MultiSystemDebugger
extends VBoxContainer
tool

var systems_query := Traitor.query("Systems Query", [Systems])

func _ready() -> void:
	rebuild()

func rebuild() -> void:
	for child in get_children():
		if child.has_meta("multi_system_debugger_child"):
			remove_child(child)
			child.queue_free()

	var systems_node = systems_query.run_single(get_tree())
	var systems = Systems.get_systems(systems_node)
	for system in systems:
		var system_label = Label.new()
		system_label.text = system.get_name()
		system_label.set_meta("multi_system_debugger_child", true)
		add_child(system_label)

		var queries = Queries.get_queries(system)
		for query in queries:
			var query_label = Label.new()
			query_label.text = query.get_name()
			query_label.set_meta("multi_system_debugger_child", true)
			add_child(query_label)

			var query_debugger = QueryDebugger.new()
			query_debugger.set_meta("multi_system_debugger_child", true)
			query_debugger.set_query(query)
			query_debugger.size_flags_horizontal = SIZE_EXPAND_FILL
			add_child(query_debugger)
