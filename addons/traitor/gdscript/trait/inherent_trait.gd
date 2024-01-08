""" A Trait predicated on the inherent properties of some node type """

class_name InherentTrait
extends Trait
tool

var type

func _name() -> String:
	return "InherentTrait"

func _is_implementor(node: Node) -> bool:
	return node is type
