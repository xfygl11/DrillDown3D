# 建筑工 - 建造其他建筑
extends "res://scripts/building/building.gd"

class_name Constructor

var build_queue: Array = []
var current_building: Dictionary = {}

func _init(x: int, y: int, z: int) -> void:
	super._init(BuildingType.CONSTRUCTOR, x, y, z)
	production_time = 10.0

func can_accept(item: Dictionary) -> bool:
	var allowed = ["stone", "iron_ingot", "copper_ingot", "steel_ingot"]
	return item.type in allowed

func accept_item(item: Dictionary) -> bool:
	if input_slots.size() >= 4:
		return false
	for existing in input_slots:
		if existing.type == item.type:
			existing.amount += item.amount
			return true
	input_slots.append({"type": item.type, "amount": item.amount})
	return true

func start_construction(building_type: String, cost: Dictionary) -> bool:
	if not can_afford(cost):
		return false
	
	# 扣除材料
	for item in cost:
		GameManager.remove_resource(item, cost[item])
	
	build_queue.append({
		"type": building_type,
		"progress": 0.0,
		"time": production_time
	})
	print("[Constructor] 开始建造: %s" % building_type)
	return true

func can_afford(cost: Dictionary) -> bool:
	for item in cost:
		if GameManager.resources.get(item, 0) < cost[item]:
			return false
	return true

func produce(delta_time: float) -> Dictionary:
	if not is_powered or not is_operational:
		return {}
	
	if build_queue.is_empty():
		return {}
	
	var task = build_queue[0]
	task["progress"] += delta_time
	
	if task["progress"] >= task["time"]:
		build_queue.pop_front()
		print("[Constructor] 建造完成: %s" % task["type"])
		return {"type": task["type"], "completed": true}
	
	return {}

func get_queue_size() -> int:
	return build_queue.size()

func get_build_progress() -> float:
	if build_queue.is_empty():
		return 0.0
	var task = build_queue[0]
	return task["progress"] / task["time"]
