# Distributor - 分流器
# 对应文档建筑类型列表
extends Building

class_name Distributor

func _init(x: int = 0, y: int = 0, z: int = 0) -> void:
	super._init(BuildingType.DISTRIBUTOR, x, y, z)
	display_name = "分流器"
	size = Vector3i(1, 1, 1)
	power_consumption = 2.0
	description = "将物品分流到多个出口"

func _process(delta: float) -> void:
	super._process(delta)
	# 分流器逻辑
