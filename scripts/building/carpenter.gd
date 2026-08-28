# Carpenter - 木工坊
# 对应文档建筑类型列表
extends Building

class_name Carpenter

func _init() -> void:
	super._init(BuildingType.CARPENTER)
	display_name = "木工坊"
	size = Vector3i(2, 2, 1)
	power_consumption = 15.0
	description = "制作木制组件"

func _process(delta: float) -> void:
	super._process(delta)
	# 木工坊生产逻辑
