# MiningSystem - 采矿系统
extends Node

class_name MiningSystem

signal resource_gathered(resource_type: String, amount: int)
signal mining_complete(tile_type: String)

var is_mining: bool = false

func start_mining(tile_type: String) -> void:
	is_mining = true
	print("[Mining] 开始采矿: %s" % tile_type)

func stop_mining() -> void:
	is_mining = false
	print("[Mining] 停止采矿")

func gather_resource(resource_type: String, amount: int) -> void:
	resource_gathered.emit(resource_type, amount)

func complete_mining(tile_type: String) -> void:
	mining_complete.emit(tile_type)
