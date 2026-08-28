# PowerPole - 电线杆
# 对应文档建筑类型列表
extends Building

class_name PowerPole

func _init() -> void:
	super._init(BuildingType.POWER_POLE)
	display_name = "电线杆"
	size = Vector3i(1, 3, 1)
	description = "架设高压输电线路"

func _process(delta: float) -> void:
	super._process(delta)
	# 电线杆逻辑
