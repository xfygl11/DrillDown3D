# 组装机 - 物品合成建筑
extends "res://scripts/building/building.gd"

class_name Assembler

func _init(x: int, y: int, z: int) -> void:
	super._init(BuildingType.ASSEMBLER, x, y, z)
	production_time = 3.0

func can_accept(item: Dictionary) -> bool:
	var allowed = ["iron_ore", "copper_ore", "coal", "sand"]
	return item.type in allowed

func accept_item(item: Dictionary) -> bool:
	if input_slots.size() >= 2:
		return false
	for existing in input_slots:
		if existing.type == item.type:
			existing.amount += item.amount
			return true
	input_slots.append({
		"type": item.type,
		"amount": item.amount
	})
	return true

func produce(delta_time: float) -> Dictionary:
	if not is_powered or not is_operational:
		return {}
	
	if input_slots.size() < 2:
		return {}
	
	production_progress += delta_time
	
	if production_progress >= production_time:
		production_progress = 0.0
		var output_type = "steel_ingot" if "iron_ore" in input_slots[0]["type"] else "copper_ingot"
		input_slots.clear()
		print("[Assembler] 合成完成: %s" % output_type)
		return {"type": output_type, "amount": 1}
	
	return {}
