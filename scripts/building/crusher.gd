# 破碎机 - 粉碎矿石
extends "res://scripts/building/building.gd"

class_name Crusher

var crush_speed: float = 0.3

func _init(x: int, y: int, z: int) -> void:
	super._init(BuildingType.CRUSHER, x, y, z)
	production_time = 3.0

func can_accept(item: Dictionary) -> bool:
	var allowed = ["stone", "iron_ore", "copper_ore", "coal_ore"]
	return item.type in allowed

func accept_item(item: Dictionary) -> bool:
	if input_slots.size() >= 2:
		return false
	for existing in input_slots:
		if existing.type == item.type:
			existing.amount += item.amount
			return true
	input_slots.append({"type": item.type, "amount": item.amount})
	return true

func produce(delta_time: float) -> Dictionary:
	if not is_powered or not is_operational:
		return {}
	
	if input_slots.is_empty():
		return {}
	
	production_progress += delta_time * crush_speed
	
	if production_progress >= production_time:
		production_progress = 0.0
		var input = input_slots.pop_front()
		var output_amount = int(input.amount * 1.5)
		print("[Crusher] 破碎完成: %s x%d -> x%d" % [input.type, input.amount, output_amount])
		return {"type": input.type, "amount": output_amount}
	
	return {}
