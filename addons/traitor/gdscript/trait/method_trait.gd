""" A Trait predicated on the presence of a method with a given name """

class_name MethodTrait
extends Trait
tool

var method: String

func _name() -> String:
	return "MethodTrait"

func _is_implementor(node: Node) -> bool:
	return node.has_method(method)

func call_method():
	return get_node().call(method)
