# 水泵 - 抽取地下水
extends "res://scripts/building/building.gd"

class_name WaterPump

var water_output: float = 5.0

func _init(x: int, y: int, z: int) -> void:
	super._init(BuildingType.WATER_PUMP, x, y, z)

func produce(delta_time: float) -> Dictionary:
	if not is_powered or not is_operational:
		return {}
	
	production_progress += delta_time
	
	if production_progress >= 1.0:
		production_progress = 0.0
		print("[WaterPump] 抽水: %.0f" % water_output)
		return {"type": "water", "amount": int(water_output)}
	
	return {}
