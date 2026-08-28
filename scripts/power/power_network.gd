# PowerNetwork - 电力系统
# 对应 Python PowerNetwork.py
extends Node

class_name PowerNetwork

var network_id: int
var sources: Array = []
var consumers: Array = []
var total_generation: float = 0.0
var total_consumption: float = 0.0
var available_power: float = 0.0

func _init(id: int) -> void:
	network_id = id

func add_source(source: Node) -> void:
	sources.append(source)

func add_consumer(consumer: Node) -> void:
	consumers.append(consumer)

func remove_source(source: Node) -> void:
	if source in sources:
		sources.remove_at(sources.find(source))

func remove_consumer(consumer: Node) -> void:
	if consumer in consumers:
		consumers.remove_at(consumers.find(consumer))

func update(delta_time: float) -> void:
	# 计算总发电
	total_generation = 0.0
	for source in sources:
		total_generation += source.call("generate", delta_time)
	
	# 计算总需求
	total_consumption = 0.0
	for consumer in consumers:
		total_consumption += consumer.power_demand
	
	# 计算可用电力
	available_power = total_generation
	
	# 分配电力
	_distribute_power()

func _distribute_power() -> void:
	if total_generation >= total_consumption:
		# 电力充足，全部满足
		for consumer in consumers:
			consumer.call("update", consumer.power_demand)
	else:
		# 电力不足，按比例分配
		var ratio = total_generation / total_consumption if total_consumption > 0 else 0.0
		for consumer in consumers:
			consumer.call("update", consumer.power_demand * ratio)

func get_utilization() -> float:
	if total_consumption == 0:
		return 100.0
	return min(100.0, (total_generation / total_consumption) * 100)

func is_stable() -> bool:
	return total_generation >= total_consumption * 0.9
