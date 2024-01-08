""" An object that can be used to search for nodes implementing a given set of Traits """

class_name Query
tool

var owner_ref: WeakRef
var name: String
var params: Array

func _init(in_owner: Node, in_name: String, in_params: Array) -> void:
	owner_ref = weakref(in_owner)
	name = in_name
	params = in_params

func run(nodes: Array) -> Dictionary:
	var results := {}
	for node in nodes:
		var result := {}
		var skip := false
		for param in params:
			var to = Trait.lift(node, param.trait)
			if param.is_valid(to):
				result[param.trait] = to
			else:
				skip = true
				break
		if not skip:
			results[node] = result
	return results

class Param:
	static func concrete(trait) -> ParamImpl:
		return ParamImpl.new(trait, ParamImpl.Type.Concrete)

	static func optional(trait) -> ParamImpl:
		return ParamImpl.new(trait, ParamImpl.Type.Optional)

	static func none(trait) -> ParamImpl:
		return ParamImpl.new(trait, ParamImpl.Type.None)

class ParamImpl:
	enum Type {
		Concrete,
		Optional,
		None
	}

	var trait
	var type: int = Type.Concrete

	func _init(in_trait, in_type: int) -> void:
		trait = in_trait
		type = in_type

	func is_valid(trait: Trait) -> bool:
		match type:
			Type.Concrete:
				return trait != null
			Type.Optional:
				return true
			Type.None:
				return trait == null

		return false
