# CraftingSystem - 合成系统
extends Node

class_name CraftingSystem

signal crafting_started(recipe_id: String)
signal crafting_completed(recipe_id: String, output: Dictionary)

var is_crafting: bool = false

func start_crafting(recipe_id: String) -> void:
	is_crafting = true
	crafting_started.emit(recipe_id)
	print("[Crafting] 开始合成: %s" % recipe_id)

func stop_crafting() -> void:
	is_crafting = false
	print("[Crafting] 停止合成")

func complete_crafting(recipe_id: String, output: Dictionary) -> void:
	crafting_completed.emit(recipe_id, output)
