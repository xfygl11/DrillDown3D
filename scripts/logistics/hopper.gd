# Hopper - 漏斗
# 对应文档建筑类型列表
extends Building

class_name Hopper

func _init() -> void:
	super._init(BuildingType.HOPPER)
	display_name = "漏斗"
	size = Vector3i(1, 1, 1)
	description = "收集并转移物品"

func _process(delta: float) -> void:
	super._process(delta)
	# 漏斗逻辑
