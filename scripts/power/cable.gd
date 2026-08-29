# Cable - 电缆
# 对应文档建筑类型列表
extends Building

class_name Cable

func _init(x: int = 0, y: int = 0, z: int = 0) -> void:
	super._init(BuildingType.CABLE, x, y, z)
	display_name = "电缆"
	size = Vector3i(1, 1, 1)
	description = "传输电力"

func _process(delta: float) -> void:
	super._process(delta)
	# 电缆逻辑
