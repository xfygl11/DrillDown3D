# 蒸汽涡轮 - 电力生产建筑
extends "res://scripts/building/building.gd"

class_name Turbine

var power_output: float = 50.0
var steam_input: float = 10.0

func _init(x: int, y: int, z: int) -> void:
	super._init(BuildingType.TURBINE, x, y, z)

func generate(delta_time: float) -> float:
	if is_operational:
		return power_output * delta_time
	return 0.0

func on_place() -> void:
	super.on_place()
	PowerNetwork.add_consumer(self)

func on_remove() -> void:
	super.on_remove()
	PowerNetwork.remove_consumer(self)

@property
var power_demand() -> float:
	return power_output if is_operational else 0.0
