# 物品系统 - 物品定义和转换
extends Node

class_name ItemSystem

const ITEM_TYPES = {
	"stone": {"name": "Stone", "stack_size": 64, "rarity": 1},
	"iron_ore": {"name": "Iron Ore", "stack_size": 64, "rarity": 2},
	"copper_ore": {"name": "Copper Ore", "stack_size": 64, "rarity": 2},
	"coal_ore": {"name": "Coal Ore", "stack_size": 64, "rarity": 2},
	"gold_ore": {"name": "Gold Ore", "stack_size": 32, "rarity": 3},
	"iron_ingot": {"name": "Iron Ingot", "stack_size": 64, "rarity": 2},
	"copper_ingot": {"name": "Copper Ingot", "stack_size": 64, "rarity": 2},
	"steel_ingot": {"name": "Steel Ingot", "stack_size": 32, "rarity": 3},
	"crude_oil": {"name": "Crude Oil", "stack_size": 128, "rarity": 1},
	"fuel": {"name": "Fuel", "stack_size": 128, "rarity": 1}
}

func get_item_info(item_type: String) -> Dictionary:
	return ITEM_TYPES.get(item_type, {"name": "Unknown", "stack_size": 64, "rarity": 0})

func is_resource(item_type: String) -> bool:
	return item_type in ITEM_TYPES

func get_rarity_name(rarity: int) -> String:
	var names = {1: "Common", 2: "Uncommon", 3: "Rare", 4: "Epic", 5: "Legendary"}
	return names.get(rarity, "Unknown")
