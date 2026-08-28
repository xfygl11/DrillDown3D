# Conveyor - 传送带系统
# 对应 Python Conveyor.py
extends "res://scripts/building/building.gd"

class_name Conveyor

var items: Array = []
var max_capacity: int = 7
var speed: float = 5.0
var last_move_time: float = 0.0

func _init(x: int, y: int, z: int, dir: Building.Direction = Building.Direction.EAST) -> void:
	super._init(BuildingType.CONVEYOR, x, y, z)
	direction = dir

func can_accept(item: Dictionary) -> bool:
	return items.size() < max_capacity

func accept_item(item: Dictionary) -> bool:
	if items.size() >= max_capacity:
		return false
	for existing in items:
		if existing.type == item.type:
			existing.amount += item.amount
			return true
	items.append({
		"type": item.type,
		"amount": item.amount
	})
	return true

func remove_item() -> Dictionary:
	if items.is_empty():
		return {}
	return items.pop_front()

func get_fill_percentage() -> float:
	return (items.size() / max_capacity) * 100
