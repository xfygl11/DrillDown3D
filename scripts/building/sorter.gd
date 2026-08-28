# 分拣机 - 自动分类物品
extends "res://scripts/building/building.gd"

class_name Sorter

var output_directions: Dictionary = {}

func _init(x: int, y: int, z: int, direction: String = "right") -> void:
	super._init(BuildingType.SORTER, x, y, z)

func can_accept(item: Dictionary) -> bool:
	return output_slots.size() < 1

func accept_item(item: Dictionary) -> bool:
	if output_slots.size() >= 1:
		return false
	output_slots.append(item.duplicate())
	print("[Sorter] 接收物品: %s x%d" % [item.type, item.amount])
	return true

func produce(delta_time: float) -> Dictionary:
	if not is_powered or not is_operational:
		return {}
	
	if output_slots.is_empty():
		return {}
	
	production_progress += delta_time
	
	if production_progress >= 0.5:
		var item = output_slots.pop_front()
		production_progress = 0.0
		print("[Sorter] 输出物品: %s x%d" % [item.type, item.amount])
		return item
	
	return {}

func add_output_direction(direction: String) -> void:
	output_directions[direction] = true
