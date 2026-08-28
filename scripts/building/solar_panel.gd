# SolarPanel - 太阳能板
# 对应文档建筑类型列表
extends Building

class_name SolarPanel

func _init() -> void:
	super._init()
	building_type = BuildingType.SOLAR_PANEL
	display_name = "太阳能板"
	size = Vector3i(2, 1, 1)
	power_output = 15.0
	recipes = []
	description = "利用太阳能产生电力（白天有效）"

func _process(delta: float) -> void:
	super._process(delta)
	# 太阳能发电逻辑 - 白天发电，晚上不发电
	if GameManager.instance.game_time > 3600 and GameManager.instance.game_time < 72000:
		power_generated = power_output
	else:
		power_generated = 0.0
