class_name TraitQuery
extends Resource
tool

export(Array, Script) var traits := []

func run(tree: SceneTree) -> Array:
	var group_names := []
	for trait in traits:
		group_names.append(Trait.group_name(trait))

	var candidates := []
	for name in group_names:
		var nodes = tree.get_nodes_in_group(name)
		for node in nodes:
			if not node in candidates:
				candidates.append(node)

	var results := []
	for node in candidates:
		var all_groups := true
		for name in group_names:
			if not node.is_in_group(name):
				all_groups = false
				break
		if all_groups:
			results.append(node)

	return results

func run_single(tree: SceneTree) -> Node:
	var result = run(tree)
	if result.size() > 0:
		return result[0]
	else:
		return null
