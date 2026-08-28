# GasTurbine - 燃气涡轮发电机
# 对应文档建筑类型列表
extends Building

class_name GasTurbine

func _init() -> void:
	super._init()
	building_type = BuildingType.GAS_TURBINE
	display_name = "燃气涡轮"
	size = Vector3i(3, 3, 1)
	power_output = 200.0
	recipes = []
	description = "燃烧气体产生大量电力"

func _process(delta: float) -> void:
	super._process(delta)
	# 燃气涡轮发电逻辑
	if has_input_resource("gas"):
		power_generated = power_output
		remove_input_resource("gas", delta * 10)
