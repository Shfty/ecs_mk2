class_name SystemButtons
extends VBoxContainer
tool

signal system_selected(system)

var systems_query := Traitor.query("Systems Query", [Systems])

func _ready() -> void:
	rebuild()

func on_item_selected(index: int) -> void:
	var systems_node = systems_query.run_single(get_tree())
	var systems = Systems.get_systems(systems_node)
	emit_signal("system_selected", systems[index])

func rebuild() -> void:
	for child in get_children():
		if child.has_meta("system_buttons_child"):
			remove_child(child)
			child.queue_free()

	var systems_node = systems_query.run_single(get_tree())
	if not systems_node:
		return

	var systems = Systems.get_systems(systems_node)
	var button_group = ButtonGroup.new()
	for i in range(0, systems.size()):
		var system = systems[i]
		var button = Button.new()
		button.text = system.get_name()
		button.size_flags_horizontal = SIZE_EXPAND_FILL
		button.action_mode = BaseButton.ACTION_MODE_BUTTON_PRESS
		button.toggle_mode = true
		button.group = button_group
		button.connect("pressed", self, "on_item_selected", [i])
		button.set_meta("system_buttons_child", true)
		add_child(button)
	emit_signal("system_selected", systems[0])
	get_child(0).pressed = true
