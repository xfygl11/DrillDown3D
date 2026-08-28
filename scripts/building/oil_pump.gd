# 抽油机 - 石油开采建筑
extends "res://scripts/building/building.gd"

class_name OilPump

var production_rate: float = 2.0

func _init(x: int, y: int, z: int) -> void:
	super._init(BuildingType.OIL_PUMP, x, y, z)
	production_time = 2.0

func produce(delta_time: float) -> Dictionary:
	if not is_powered or not is_operational:
		return {}
	
	production_progress += delta_time
	
	if production_progress >= production_time:
		production_progress = 0.0
		var amount = randi() % 3 + 1
		print("[OilPump] 产出: 原油 x%d" % amount)
		return {"type": "crude_oil", "amount": amount}
	
	return {}
