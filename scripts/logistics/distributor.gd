# Distributor - 分流器
# 对应文档建筑类型列表
extends Building

class_name Distributor

func _init() -> void:
	super._init(BuildingType.DISTRIBUTOR)
	display_name = "分流器"
	size = Vector3i(1, 1, 1)
	power_consumption = 2.0
	description = "将物品分流到多个出口"

func _process(delta: float) -> void:
	super._process(delta)
	# 分流器逻辑
