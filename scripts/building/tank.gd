# Tank - 流体储罐
# 对应文档建筑类型列表
extends Building

class_name Tank

var stored_fluid: Dictionary = {}
var max_capacity: float = 1000.0

func _init() -> void:
	super._init(BuildingType.TANK)
	display_name = "流体储罐"
	size = Vector3i(2, 2, 1)
	description = "存储流体"

func _process(delta: float) -> void:
	super._process(delta)
	# 储罐逻辑
