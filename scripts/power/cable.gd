# Cable - 电缆
# 对应文档建筑类型列表
extends Building

class_name Cable

func _init() -> void:
	super._init(BuildingType.CABLE)
	display_name = "电缆"
	size = Vector3i(1, 1, 1)
	description = "传输电力"

func _process(delta: float) -> void:
	super._process(delta)
	# 电缆逻辑
