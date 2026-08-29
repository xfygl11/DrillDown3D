# SolarPanel - 太阳能板
# 对应文档建筑类型列表
extends Building

class_name SolarPanel

func _init(x: int = 0, y: int = 0, z: int = 0) -> void:
	super._init(BuildingType.SOLAR_PANEL, x, y, z)
	display_name = "太阳能板"
	size = Vector3i(2, 1, 1)
	power_generated = 15.0
	description = "利用太阳能产生电力（白天有效）"

func _process(delta: float) -> void:
	super._process(delta)
	# 太阳能发电逻辑 - 白天发电，晚上不发电
	var gm = get_node("/root/GameManager")
	if gm:
		var game_time = gm.game_time
		if game_time > 3600 and game_time < 72000:
			power_generated = 15.0  # 白天发电
		else:
			power_generated = 0.0  # 晚上不发电
