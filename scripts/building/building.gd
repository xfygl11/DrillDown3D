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
	CABLE,
	OIL_PUMP,
	SMELTER,
	WATER_PUMP,
	CONSTRUCTOR,
	TRANSPORTER,
	CRUSHER,
	ELECTRIC_FURNACE,
	SORTER,
	CHARGER,
	INCINERATOR,
	RECYCLER,
	FACTORY,
	WAREHOUSE,
	WATER_WHEEL,
	SOLAR_PANEL,
	GAS_TURBINE,
	DISTILLATION_COLUMN,
	BALL_MILL,
	ROCK_CRUSHER,
	SAW_MILL,
	CARPENTER,
	TANK,
	HOPPER,
	FILTER,
	DISTRIBUTOR,
	POWER_POLE,
	CAPACITOR
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
var power_consumption: float = 0.0
var power_generated: float = 0.0
var display_name: String = ""
var description: String = ""
var recipes: Array = []
var size: Vector3i = Vector3i(1, 1, 1)

func _init(building_type: BuildingType = BuildingType.SHAFT_DRILL, x: int = 0, y: int = 0, z: int = 0) -> void:
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

func get_type_name() -> String:
	match type:
		BuildingType.SHAFT_DRILL: return "竖井钻机"
		BuildingType.BOILER: return "锅炉"
		BuildingType.TURBINE: return "蒸汽涡轮"
		BuildingType.FURNACE: return "熔炉"
		BuildingType.ASSEMBLER: return "组装机"
		BuildingType.REFINERY: return "炼油厂"
		BuildingType.STORAGE: return "存储箱"
		BuildingType.CONVEYOR: return "传送带"
		BuildingType.OIL_PUMP: return "抽油机"
		BuildingType.SMELTER: return "冶炼厂"
		BuildingType.WATER_PUMP: return "水泵"
		BuildingType.CONSTRUCTOR: return "建筑工"
		BuildingType.TRANSPORTER: return "运输机"
		BuildingType.CRUSHER: return "破碎机"
		BuildingType.ELECTRIC_FURNACE: return "电炉"
		BuildingType.SORTER: return "分拣机"
		BuildingType.CHARGER: return "充电站"
		BuildingType.INCINERATOR: return "焚烧炉"
		BuildingType.RECYCLER: return "回收站"
		BuildingType.FACTORY: return "工厂"
		BuildingType.WAREHOUSE: return "仓库"
		BuildingType.WATER_WHEEL: return "水轮发电机"
		BuildingType.SOLAR_PANEL: return "太阳能板"
		BuildingType.GAS_TURBINE: return "燃气涡轮"
		BuildingType.DISTILLATION_COLUMN: return "分馏塔"
		BuildingType.BALL_MILL: return "球磨机"
		BuildingType.ROCK_CRUSHER: return "岩石破碎机"
		BuildingType.SAW_MILL: return "锯木厂"
		BuildingType.CARPENTER: return "木工坊"
		BuildingType.TANK: return "流体储罐"
		BuildingType.HOPPER: return "漏斗"
		BuildingType.FILTER: return "过滤器"
		BuildingType.DISTRIBUTOR: return "分流器"
		BuildingType.POWER_POLE: return "电线杆"
		BuildingType.CABLE: return "电缆"
		BuildingType.CAPACITOR: return "电容器"
		_: return "未知建筑"
