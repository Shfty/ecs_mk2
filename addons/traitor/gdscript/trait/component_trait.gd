""" A Trait predicated on the presence of a child node of a given type """

class_name ComponentTrait
extends Trait
tool

var component

func _name() -> String:
	return "ComponentTrait"

func _is_implementor(node: Node) -> bool:
	for child in node.get_children():
		if child is component and not child.has_meta("is_pending_remove"):
			return true
	return false

func get_component():
	for child in get_node().get_children():
		if child is component and not child.has_meta("is_pending_remove"):
			return child
	return null
