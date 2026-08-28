# 回收站 - 回收物品
extends "res://scripts/building/building.gd"

class_name Recycler

func _init(x: int, y: int, z: int) -> void:
	super._init(BuildingType.RECYCLER, x, y, z)
	production_time = 3.0

func can_accept(item: Dictionary) -> bool:
	var recyclable = ["iron_ingot", "copper_ingot", "steel_ingot", "glass"]
	return item.type in recyclable

func accept_item(item: Dictionary) -> bool:
	if input_slots.size() >= 1:
		return false
	input_slots.append({"type": item.type, "amount": item.amount})
	return true

func produce(delta_time: float) -> Dictionary:
	if not is_powered or not is_operational:
		return {}
	
	if input_slots.is_empty():
		return {}
	
	production_progress += delta_time
	
	if production_progress >= production_time:
		production_progress = 0.0
		var input = input_slots.pop_front()
		var output_type = _get_recycled_type(input.type)
		var output_amount = int(input.amount * 0.7)
		print("[Recycler] 回收完成: %s -> %s x%d" % [input.type, output_type, output_amount])
		return {"type": output_type, "amount": output_amount}
	
	return {}

func _get_recycled_type(input_type: String) -> String:
	var outputs = {
		"iron_ingot": "scrap_iron",
		"copper_ingot": "scrap_copper",
		"steel_ingot": "scrap_steel",
		"glass": "sand"
	}
	return outputs.get(input_type, "waste")
