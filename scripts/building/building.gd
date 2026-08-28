# Building - 建筑基类
# 对应 Python Building.py
extends Node

class_name Building

enum Direction {
	NORTH,
	EAST,
	SOUTH,
	WEST,
	UP,
	DOWN
}

enum BuildingType {
	SHAFT_DRILL,
	BOILER,
	TURBINE,
	FURNACE,
	ASSEMBLER,
	REFINERY,
	STORAGE,
	CONVEYOR,
	CABLE
}

var type: BuildingType
var position: Vector3i
var direction: Direction = Direction.NORTH
var is_powered: bool = false
var is_operational: bool = false
var health: int = 100
var max_health: int = 100
var input_slots: Array = []
var output_slots: Array = []
var connections: Dictionary = {}
var production_progress: float = 0.0
var production_time: float = 1.0

func _init(building_type: BuildingType, x: int, y: int, z: int) -> void:
	type = building_type
	position = Vector3i(x, y, z)

func on_place() -> void:
	print("[Building] 建筑放置: %s at %s" % [type, position])
	is_operational = true

func on_remove() -> void:
	print("[Building] 建筑移除: %s at %s" % [type, position])
	is_operational = false
	connections.clear()

func can_accept(item: Dictionary) -> bool:
	return false

func accept_item(item: Dictionary) -> bool:
	return false

func produce(delta_time: float) -> Dictionary:
	return {}

func take_damage(damage: int) -> void:
	health = maxi(0, health - damage)
	if health <= 0:
		is_operational = false

func heal(amount: int) -> void:
	health = min(max_health, health + amount)

func get_distance_to(other: Building) -> float:
	var dx = position.x - other.position.x
	var dy = position.y - other.position.y
	var dz = position.z - other.position.z
	return sqrt(dx*dx + dy*dy + dz*dz)
