# 工厂 - 高级生产建筑
extends "res://scripts/building/building.gd"

class_name Factory

var production_line: Array = []
var output_queue: Array = []

func _init(x: int, y: int, z: int) -> void:
	super._init(BuildingType.FACTORY, x, y, z)
	production_time = 5.0

func can_accept(item: Dictionary) -> bool:
	var allowed = ["iron_ingot", "copper_ingot", "steel_ingot", "glass", "rubber"]
	return item.type in allowed

func accept_item(item: Dictionary) -> bool:
	if input_slots.size() >= 4:
		return false
	for existing in input_slots:
		if existing.type == item.type:
			existing.amount += item.amount
			return true
	input_slots.append({"type": item.type, "amount": item.amount})
	return true

func add_production_recipe(recipe: Dictionary) -> void:
	production_line.append(recipe)

func produce(delta_time: float) -> Dictionary:
	if not is_powered or not is_operational:
		return {}
	
	if input_slots.is_empty():
		return {}
	
	production_progress += delta_time
	
	if production_progress >= production_time:
		production_progress = 0.0
		var input = input_slots.pop_front()
		var output = _process_item(input)
		print("[Factory] 生产完成: %s -> %s" % [input.type, output.type])
		return output
	
	return {}

func _process_item(item: Dictionary) -> Dictionary:
	var outputs = {
		"iron_ingot": {"type": "machine_part", "amount": 1},
		"copper_ingot": {"type": "wire", "amount": 1},
		"steel_ingot": {"type": "heavy_part", "amount": 1},
		"glass": {"type": "panel", "amount": 1},
		"rubber": {"type": "tire", "amount": 1}
	}
	return outputs.get(item.type, {"type": "waste", "amount": 1})
