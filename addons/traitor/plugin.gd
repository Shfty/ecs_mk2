class_name TraitorPlugin
extends EditorPlugin
tool


func _enter_tree() -> void:
	if not ProjectSettings.has_setting("traitor/traitor/traits"):
		ProjectSettings.set_setting("traitor/traitor/traits", [])

	ProjectSettings.add_property_info({
		"name": "traitor/traitor/traits",
		"type": TYPE_ARRAY,
		"hint": 24,
		"hint_string": "%s/%s:%s" % [TYPE_STRING, PROPERTY_HINT_FILE, "*.gd"]
	})

	add_autoload_singleton("Traitor", "res://addons/traitor/gdscript/traitor.gd")
	connect("scene_changed", self, "on_scene_changed")
	Traitor.root_node = get_editor_interface().get_edited_scene_root()

func _exit_tree() -> void:
	remove_autoload_singleton("Traitor")

func on_scene_changed(scene_root: Object) -> void:
	Traitor.root_node = scene_root
