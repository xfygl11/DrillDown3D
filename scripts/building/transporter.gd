# 运输机 - 自动运输物品
extends "res://scripts/building/building.gd"

class_name Transporter

var transport_range: int = 5
var current_item: Dictionary = {}
var speed: float = 2.0

func _init(x: int, y: int, z: int) -> void:
	super._init(BuildingType.TRANSPORTER, x, y, z)

func can_accept(item: Dictionary) -> bool:
	return current_item.is_empty()

func accept_item(item: Dictionary) -> bool:
	if not current_item.is_empty():
		return false
	current_item = item.duplicate()
	print("[Transporter] 接收物品: %s x%d" % [item.type, item.amount])
	return true

func produce(delta_time: float) -> Dictionary:
	if not is_powered or not is_operational:
		return {}
	
	if current_item.is_empty():
		return {}
	
	# 模拟运输
	production_progress += delta_time * speed
	
	if production_progress >= 1.0:
		var item = current_item
		current_item = {}
		production_progress = 0.0
		print("[Transporter] 运输完成: %s x%d" % [item.type, item.amount])
		return item
	
	return {}

func has_item() -> bool:
	return not current_item.is_empty()

func get_current_item() -> Dictionary:
	return current_item.duplicate()
