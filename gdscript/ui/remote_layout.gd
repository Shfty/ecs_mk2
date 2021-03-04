class_name RemoteLayout
extends Control
tool

export(NodePath) var target := NodePath()
export(bool) var use_position := true
export(bool) var use_size := true
export(bool) var use_min_size := true

func _process(_delta: float) -> void:
	var node = get_node_or_null(target) as Control
	if not node:
		return

	if use_position:
		set_global_position(node.get_global_position())

	if use_size:
		set_size(node.get_size())

	if use_min_size:
		rect_min_size = node.rect_min_size
