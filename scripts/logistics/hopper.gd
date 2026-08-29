# Hopper - 漏斗
# 对应文档建筑类型列表
extends Building

class_name Hopper

func _init(x: int = 0, y: int = 0, z: int = 0) -> void:
	super._init(BuildingType.HOPPER, x, y, z)
	display_name = "漏斗"
	size = Vector3i(1, 1, 1)
	description = "收集并转移物品"

func _process(delta: float) -> void:
	super._process(delta)
	# 漏斗逻辑
