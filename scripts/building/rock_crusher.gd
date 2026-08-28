# RockCrusher - 岩石破碎机
# 对应文档建筑类型列表
extends Building

class_name RockCrusher

func _init() -> void:
	super._init(BuildingType.ROCK_CRUSHER)
	display_name = "岩石破碎机"
	size = Vector3i(2, 2, 1)
	power_consumption = 25.0
	description = "破碎岩石得到砾石"

func _process(delta: float) -> void:
	super._process(delta)
	# 破碎机生产逻辑
