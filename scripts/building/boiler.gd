# 锅炉 - 蒸汽动力源
extends "res://scripts/building/building.gd"

class_name Boiler

var steam_output: float = 10.0

func _init(x: int, y: int, z: int) -> void:
	super._init(BuildingType.BOILER, x, y, z)

func generate(delta_time: float) -> float:
	if is_operational and is_powered:
		return steam_output * delta_time
	return 0.0

func on_place() -> void:
	super.on_place()
	print("[Boiler] 锅炉放置于 %s" % position)
	PowerNetwork.add_source(self)

func on_remove() -> void:
	super.on_remove()
	PowerNetwork.remove_source(self)
