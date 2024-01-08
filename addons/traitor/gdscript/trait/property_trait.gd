""" A Trait predicated on the presence of a property with a given name """

class_name PropertyTrait
extends Trait
tool

var property: String

func _name() -> String:
	return "PropertyTrait"

func _is_implementor(node: Node) -> bool:
	return node.has_property(property)

func get_property():
	return get_node().get(property)

func set_property(new_value) -> void:
	 get_node().set(property, new_value)
