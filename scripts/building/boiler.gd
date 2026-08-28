# 锅炉 - 蒸汽动力源
extends "res://scripts/building/building.gd"

class_name Boiler

var steam_output: float = 10.0
var _power_network: PowerNetwork = null

func _ready() -> void:
	_power_network = get_node("/root/PowerNetwork")

func _init(x: int, y: int, z: int) -> void:
	super._init(BuildingType.BOILER, x, y, z)

func generate(delta_time: float) -> float:
	if is_operational and is_powered:
		return steam_output * delta_time
	return 0.0

func on_place() -> void:
	super.on_place()
	print("[Boiler] 锅炉放置于 %s" % position)
	if _power_network:
		_power_network.add_source(self)

func on_remove() -> void:
	super.on_remove()
	if _power_network:
		_power_network.remove_source(self)
