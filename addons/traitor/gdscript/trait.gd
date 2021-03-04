"""
Abstract base class for interfaces
"""

class_name Trait
extends Resource
tool

static func name() -> String:
	# name must be implemented for traits to work correctly
	breakpoint
	return "Trait"

static func group_name(trait) -> String:
	var re = RegEx.new()
	re.compile("(?<!^)(?=[A-Z])")
	var group_name = re.sub(trait.name(), '_', true).to_lower()
	return group_name

static func is_implementor(node: Node) -> bool:
	return false

static func debug_string(node: Node) -> String:
	return "[Trait:%s]" % [node.get_instance_id()]

func _init() -> void:
	if get_name().empty():
		set_name(name())
