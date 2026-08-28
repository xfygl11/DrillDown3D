# 城市系统 - 人口和需求
extends Node

class_name CitySystem

signal population_changed(old_pop: int, new_pop: int)
signal demand_updated(demand_type: String, amount: int)

var population: int = 0
var max_population: int = 100
var happiness: float = 50.0
var demands: Dictionary = {
	"food": 0,
	"tools": 0,
	"clothes": 0,
	"weapons": 0
}

func _process(delta: float) -> void:
	# 模拟人口增长
	if population < max_population and happiness > 30:
		population = min(max_population, population + delta * 0.1)
		if population != int(population):
			population_changed.emit(int(population) - 1, int(population))

func update_happiness(factor: String, value: float) -> void:
	match factor:
		"jobs":
			happiness = clamp(happiness + value, 0, 100)
		"services":
			happiness = clamp(happiness + value, 0, 100)
		"pollution":
			happiness = clamp(happiness - value, 0, 100)

func add_demand(demand_type: String, amount: int) -> void:
	demands[demand_type] = demands.get(demand_type, 0) + amount
	demand_updated.emit(demand_type, amount)
	print("[City] 新增需求: %s x%d" % [demand_type, amount])

func fulfill_demand(demand_type: String, amount: int) -> bool:
	if demand_type not in demands or demands[demand_type] < amount:
		return false
	demands[demand_type] -= amount
	demand_updated.emit(demand_type, -amount)
	return true

func get_satisfaction_rate() -> float:
	var total_demands = demands.values().sum()
	if total_demands == 0:
		return 100.0
	return 100.0 - (demands.values().sum() / max_population) * 100

func can_support_population(new_pop: int) -> bool:
	return new_pop <= max_population
