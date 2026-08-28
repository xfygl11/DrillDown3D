# 炼油厂 - 原油加工建筑
extends "res://scripts/building/building.gd"

class_name Refinery

var output_rate: float = 5.0

func _init(x: int, y: int, z: int) -> void:
	super._init(BuildingType.REFINERY, x, y, z)
	production_time = 10.0

func can_accept(item: Dictionary) -> bool:
	return item.type == "crude_oil"

func accept_item(item: Dictionary) -> bool:
	if input_slots.size() >= 1:
		return false
	input_slots.append({
		"type": item.type,
		"amount": item.amount
	})
	return true

func produce(delta_time: float) -> Dictionary:
	if not is_powered or not is_operational:
		return {}
	
	if input_slots.is_empty():
		return {}
	
	production_progress += delta_time
	
	if production_progress >= production_time:
		production_progress = 0.0
		var oil_amount = input_slots[0]["amount"]
		input_slots.clear()
		print("[Refinery] 炼油完成: %d 原油 -> %d 燃油" % [oil_amount, int(oil_amount * 0.8)])
		return {"type": "fuel", "amount": int(oil_amount * 0.8)}
	
	return {}
