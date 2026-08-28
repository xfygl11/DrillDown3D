# 竖井钻机 - 主要采矿建筑
extends "res://scripts/building/building.gd"

class_name ShaftDrill

func _init(x: int, y: int, z: int) -> void:
	super._init(BuildingType.SHAFT_DRILL, x, y, z)
	production_time = 1.0

func on_place() -> void:
	super.on_place()
	print("[ShaftDrill] 竖井钻机放置于 %s" % position)

func produce(delta_time: float) -> Dictionary:
	if not is_powered or not is_operational:
		return {}
	
	production_progress += delta_time
	
	if production_progress >= production_time:
		production_progress = 0.0
		var output = {
			"type": "stone",
			"amount": randi() % 3 + 1
		}
		print("[ShaftDrill] 产出: %s x%d" % [output["type"], output["amount"]])
		return output
	
	return {}
