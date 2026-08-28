# DistillationColumn - 分馏塔
# 对应文档建筑类型列表
extends Building

class_name DistillationColumn

func _init() -> void:
	super._init()
	building_type = BuildingType.DISTILLATION_COLUMN
	display_name = "分馏塔"
	size = Vector3i(2, 4, 1)
	power_consumption = 50.0
	recipes = []
	description = "原油分馏生产各种燃料"

func _process(delta: float) -> void:
	super._process(delta)
	# 分馏塔生产逻辑
