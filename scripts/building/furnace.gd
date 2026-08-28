# Furnace - 熔炉建筑
# 对应 Python Furnace.py
extends "res://scripts/building/building.gd"

class_name Furnace

func _init(x: int, y: int, z: int) -> void:
	super._init(BuildingType.FURNACE, x, y, z)
	production_time = 7.5

func can_accept(item: Dictionary) -> bool:
	var allowed = ["iron_ore", "copper_ore", "coal_ore", "coal"]
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
	
	var has_ore = false
	var has_fuel = false
	for input in input_slots:
		if input.type in ["iron_ore", "copper_ore"]:
			has_ore = true
		if input.type in ["coal_ore", "coal"]:
			has_fuel = true
	
	if not has_ore or not has_fuel:
		return {}
	
	production_progress += delta_time
	
	if production_progress >= production_time:
		production_progress = 0
		# 消耗输入
		input_slots = input_slots.filter(func(item): return item.type not in ["iron_ore", "copper_ore", "coal_ore", "coal"])
		# 生成输出
		var ore_type = "iron_ore" if has_ore else "copper_ore"
		var output_type = "molten_iron" if ore_type == "iron_ore" else "molten_copper"
		print("[Furnace] 生产完成: %s -> %s" % [ore_type, output_type])
		return {"type": output_type, "amount": 1}
	
	return {}

func get_production_percentage() -> float:
	return min(100.0, (production_progress / production_time) * 100)
