# 焚烧炉 - 处理废物
extends "res://scripts/building/building.gd"

class_name Incinerator

var burn_speed: float = 0.5

func _init(x: int, y: int, z: int) -> void:
	super._init(BuildingType.INCINERATOR, x, y, z)
	production_time = 2.0

func can_accept(item: Dictionary) -> bool:
	var waste_items = ["slag", "waste", "ash"]
	return item.type in waste_items

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
	
	production_progress += delta_time * burn_speed
	
	if production_progress >= production_time:
		production_progress = 0.0
		var input = input_slots.pop_front()
		print("[Incinerator] 焚烧完成: %s x%d" % [input.type, input.amount])
		return {"type": "ash", "amount": int(input.amount * 0.1)}
	
	return {}
