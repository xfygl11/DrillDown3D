# 冶炼厂 - 高级熔炼建筑
extends "res://scripts/building/building.gd"

class_name Smelter

var smelt_speed: float = 0.5
var output_quality: int = 1

func _init(x: int, y: int, z: int) -> void:
	super._init(BuildingType.SMELTER, x, y, z)
	production_time = 5.0

func can_accept(item: Dictionary) -> bool:
	var allowed = ["iron_ore", "copper_ore", "gold_ore", "tin_ore"]
	return item.type in allowed

func accept_item(item: Dictionary) -> bool:
	if input_slots.size() >= 3:
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
	
	production_progress += delta_time * smelt_speed
	
	if production_progress >= production_time:
		production_progress = 0.0
		var input = input_slots.pop_front()
		var output_type = _get_output_type(input.type)
		var output_amount = int(input.amount * 0.8)
		print("[Smelter] 冶炼完成: %s -> %s x%d" % [input.type, output_type, output_amount])
		return {"type": output_type, "amount": output_amount}
	
	return {}

func _get_output_type(input_type: String) -> String:
	var outputs = {
		"iron_ore": "molten_iron",
		"copper_ore": "molten_copper",
		"gold_ore": "molten_gold",
		"tin_ore": "molten_tin"
	}
	return outputs.get(input_type, "slag")
