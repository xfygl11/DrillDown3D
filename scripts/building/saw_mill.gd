# SawMill - 锯木厂
# 对应文档建筑类型列表
extends Building

class_name SawMill

func _init() -> void:
	super._init(BuildingType.SAW_MILL)
	display_name = "锯木厂"
	size = Vector3i(2, 2, 1)
	power_consumption = 20.0
	description = "将原木加工成木材"

func _process(delta: float) -> void:
	super._process(delta)
	# 锯木厂生产逻辑
