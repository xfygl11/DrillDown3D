# 充电站 - 为电池充电
extends "res://scripts/building/building.gd"

class_name Charger

var charge_rate: float = 10.0

func _init(x: int, y: int, z: int) -> void:
	super._init(BuildingType.CHARGER, x, y, z)

func can_accept(item: Dictionary) -> bool:
	return item.type == "battery" and item.amount < 100

func accept_item(item: Dictionary) -> bool:
	if input_slots.size() >= 1:
		return false
	input_slots.append(item.duplicate())
	return true

func produce(delta_time: float) -> Dictionary:
	if not is_powered or not is_operational:
		return {}
	
	if input_slots.is_empty():
		return {}
	
	var battery = input_slots[0]
	battery["amount"] = min(100, battery["amount"] + charge_rate * delta_time)
	
	if battery["amount"] >= 100:
		input_slots.pop_front()
		print("[Charger] 充电完成")
		return {"type": "charged_battery", "amount": 1}
	
	return {}
