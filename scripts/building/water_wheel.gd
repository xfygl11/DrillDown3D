# WaterWheel - 水轮发电机
# 对应文档建筑类型列表
extends Building

class_name WaterWheel

func _init() -> void:
	super._init(BuildingType.WATER_WHEEL)
	display_name = "水轮发电机"
	size = Vector3i(2, 2, 1)
	power_generated = 20.0
	description = "利用水流产生电力"

func _process(delta: float) -> void:
	super._process(delta)
	# 水轮发电逻辑
