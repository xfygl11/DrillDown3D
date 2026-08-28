# 电炉 - 电力熔炼
extends "res://scripts/building/building.gd"

class_name ElectricFurnace

var power_consumption: float = 20.0

func _init(x: int, y: int, z: int) -> void:
	super._init(BuildingType.ELECTRIC_FURNACE, x, y, z)
	production_time = 2.0

func can_accept(item: Dictionary) -> bool:
	var allowed = ["iron_ore", "copper_ore", "gold_ore", "steel_scrap"]
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
	
	production_progress += delta_time
	
	if production_progress >= production_time:
		production_progress = 0.0
		var input = input_slots.pop_front()
		var output_type = _get_output_type(input.type)
		print("[ElectricFurnace] 熔炼完成: %s -> %s" % [input.type, output_type])
		return {"type": output_type, "amount": 1}
	
	return {}

func _get_output_type(input_type: String) -> String:
	var outputs = {
		"iron_ore": "iron_ingot",
		"copper_ore": "copper_ingot",
		"gold_ore": "gold_ingot",
		"steel_scrap": "steel_ingot"
	}
	return outputs.get(input_type, "slag")

@property
var power_demand() -> float:
	return power_consumption if is_operational else 0.0
