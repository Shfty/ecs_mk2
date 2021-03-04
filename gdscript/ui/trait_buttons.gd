class_name TraitButtons
extends GridContainer
tool

signal trait_toggled(trait, enabled)

func _ready() -> void:
	rebuild()

func rebuild() -> void:
	for child in get_children():
		if child.has_meta("system_buttons_child"):
			remove_child(child)
			child.queue_free()

	var traits = Traitor.get_traits()
	var button_group = ButtonGroup.new()
	for i in range(0, traits.size()):
		var trait = traits[i]
		var button = Button.new()
		button.text = trait.name()
		button.size_flags_horizontal = SIZE_EXPAND_FILL
		button.action_mode = BaseButton.ACTION_MODE_BUTTON_PRESS
		button.toggle_mode = true
		button.connect("toggled", self, "on_trait_toggled", [i])
		button.set_meta("system_buttons_child", true)
		add_child(button)

func on_trait_toggled(pressed: bool, index: int) -> void:
	var traits = Traitor.get_traits()
	emit_signal("trait_toggled", traits[index], pressed)
