# 资源管理器 - 统一管理所有资源
extends Node

class_name ResourceManager

signal resource_added(type: String, amount: int)
signal resource_removed(type: String, amount: int)

var resources: Dictionary = {
	"stone": 0,
	"iron_ore": 0,
	"copper_ore": 0,
	"coal_ore": 0,
	"gold_ore": 0,
	"tin_ore": 0,
	"iron_ingot": 0,
	"copper_ingot": 0,
	"steel_ingot": 0,
	"gold_ingot": 0,
	"crude_oil": 0,
	"fuel": 0
}

func add_resource(type: String, amount: int) -> bool:
	if type in resources:
		resources[type] += amount
		resource_added.emit(type, amount)
		return true
	print("[ResourceManager] 未知资源类型: %s" % type)
	return false

func remove_resource(type: String, amount: int) -> bool:
	if type in resources:
		if resources[type] >= amount:
			resources[type] -= amount
			resource_removed.emit(type, amount)
			return true
		print("[ResourceManager] 资源不足: %s 需要 %d, 拥有 %d" % [type, amount, resources[type]])
		return false
	print("[ResourceManager] 未知资源类型: %s" % type)
	return false

func has_resource(type: String, amount: int) -> bool:
	return resources.get(type, 0) >= amount

func get_resource(type: String) -> int:
	return resources.get(type, 0)

static func _sum_array(arr: Array) -> int:
	var total: int = 0
	for v in arr:
		if typeof(v) == TYPE_INT:
			total += v as int
	return total

func get_total_resources() -> int:
	return _sum_array(resources.values())

func clear_all() -> void:
	for key in resources:
		resources[key] = 0
	print("[ResourceManager] 所有资源已清空")
