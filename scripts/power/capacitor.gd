# Capacitor - 电容器
# 对应文档建筑类型列表
extends Building

class_name Capacitor

var stored_power: float = 0.0
var max_storage: float = 500.0

func _init() -> void:
	super._init(BuildingType.CAPACITOR)
	display_name = "电容器"
	size = Vector3i(1, 1, 1)
	description = "存储多余电力"

func _process(delta: float) -> void:
	super._process(delta)
	# 电容器充放电逻辑
	var pn = get_node("/root/PowerNetwork")
	if pn:
		if pn.total_generation > pn.total_consumption:
			stored_power = min(stored_power + delta * 10, max_storage)
		elif stored_power > 0:
			stored_power -= delta * 5
