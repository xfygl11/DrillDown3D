# Filter - 过滤器
# 对应文档建筑类型列表
extends Building

class_name Filter

func _init() -> void:
	super._init(BuildingType.FILTER)
	display_name = "过滤器"
	size = Vector3i(1, 1, 1)
	power_consumption = 5.0
	description = "筛选特定类型的物品"

func _process(delta: float) -> void:
	super._process(delta)
	# 过滤器逻辑
