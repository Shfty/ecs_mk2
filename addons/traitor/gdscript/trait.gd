""" A wrapper type that acts as a common interface to some functionality of its underlying object """

class_name Trait
tool

var node_ref: WeakRef = null

func _name() -> String:
	return "Trait"

func _group_name() -> String:
	var re = RegEx.new()
	re.compile("(?<!^)(?=[A-Z])")
	return re.sub(_name(), '_', true).to_lower()

func _is_implementor(node: Node) -> bool:
	return false

func _to_string() -> String:
	return "[%s:%s]" % [_name(), get_instance_id()]

func get_node() -> Node:
	return node_ref.get_ref()

static func lift(node: Node, trait: Script) -> Trait:
	var to = trait.new()
	if to._is_implementor(node):
		to.node_ref = weakref(node)
		return to
	return null
