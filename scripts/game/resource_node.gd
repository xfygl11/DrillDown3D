# 资源节点 - 矿物资源点
extends Node

class_name ResourceNode

enum ResourceType {
	STONE,
	IRON_ORE,
	COPPER_ORE,
	COAL_ORE,
	GOLD_ORE,
	TIN_ORE,
	CRUDE_OIL
}

var resource_type: ResourceType
var amount: int
var max_amount: int
var regeneration_rate: float = 0.0

func _init(type: ResourceType, initial_amount: int, max: int, regen: float = 0.0) -> void:
	resource_type = type
	amount = initial_amount
	max_amount = max
	regeneration_rate = regen

func extract(amount_to_extract: int) -> int:
	var actual = min(amount, amount_to_extract)
	amount -= actual
	return actual

func regenerate(delta: float) -> void:
	if regeneration_rate > 0 and amount < max_amount:
		amount = min(max_amount, amount + regeneration_rate * delta)

func is_depleted() -> bool:
	return amount <= 0

func get_remaining_percentage() -> float:
	return amount / max_amount if max_amount > 0 else 0.0

func get_resource_name() -> String:
	var names = {
		ResourceType.STONE: "Stone",
		ResourceType.IRON_ORE: "Iron Ore",
		ResourceType.COPPER_ORE: "Copper Ore",
		ResourceType.COAL_ORE: "Coal Ore",
		ResourceType.GOLD_ORE: "Gold Ore",
		ResourceType.TIN_ORE: "Tin Ore",
		ResourceType.CRUDE_OIL: "Crude Oil"
	}
	return names.get(resource_type, "Unknown")
