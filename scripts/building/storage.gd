# 存储建筑 - 资源存储
extends "res://scripts/building/building.gd"

class_name Storage

var capacity: int = 100
var stored_items: Dictionary = {}

func _init(x: int, y: int, z: int, cap: int = 100) -> void:
	super._init(BuildingType.STORAGE, x, y, z)
	capacity = cap

func can_accept(item: Dictionary) -> bool:
	var current = stored_items.get(item.type, 0)
	return current + item.amount <= capacity

func accept_item(item: Dictionary) -> bool:
	if not can_accept(item):
		return false
	stored_items[item.type] = stored_items.get(item.type, 0) + item.amount
	print("[Storage] 存储: %s x%d (总容量: %d/%d)" % [item.type, item.amount, stored_items[item.type], capacity])
	return true

func remove_item(item_type: String, amount: int) -> Dictionary:
	if not item_type in stored_items or stored_items[item_type] < amount:
		return {}
	var actual_amount = min(stored_items[item_type], amount)
	stored_items[item_type] -= actual_amount
	if stored_items[item_type] <= 0:
		stored_items.erase(item_type)
	print("[Storage] 取出: %s x%d" % [item_type, actual_amount])
	return {"type": item_type, "amount": actual_amount}

static func _sum_array(arr: Array) -> int:
	var total: int = 0
	for v in arr:
		if typeof(v) == TYPE_INT:
			total += v as int
	return total

func get_storage_info() -> Dictionary:
	return {
		"filled": _sum_array(stored_items.values()),
		"capacity": capacity,
		"items": stored_items.duplicate()
	}
