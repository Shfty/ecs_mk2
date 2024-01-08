extends EditorPlugin
tool

func _enter_tree() -> void:
	add_autoload_singleton("Traitor", "res://addons/traitor/gdscript/traitor.gd")
	connect("scene_changed", self, "on_scene_changed")

func _exit_tree() -> void:
	remove_autoload_singleton("Traitor")

func on_scene_changed(scene_root: Node) -> void:
	Traitor.set_root(scene_root)
