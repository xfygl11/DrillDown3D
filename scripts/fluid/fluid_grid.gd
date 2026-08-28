# FluidGrid - 流体网格系统
# 对应 Python FluidGrid.py
extends Node

class_name FluidGrid

# 流体类型
const FLUID_WATER = "water"
const FLUID_STEAM = "steam"
const FLUID_CRUDE_OIL = "crude_oil"
const FLUID_OIL = "oil"

var width: int = 64
var height: int = 64
var depth: int = 50
var cells: Dictionary = {}

func _init(w: int = 64, h: int = 64, d: int = 50) -> void:
	width = w
	height = h
	depth = d
	_initialize()

func _initialize() -> void:
	for x in range(width):
		for y in range(height):
			for z in range(depth):
				var key = "%d,%d,%d" % [x, y, z]
				cells[key] = {
					"x": x,
					"y": y,
					"z": z,
					"fluid_type": null,
					"amount": 0,
					"max_amount": 1000,
					"pressure": 0.0
				}

func get_cell(x: int, y: int, z: int) -> Dictionary:
	if not _is_valid(x, y, z):
		return {}
	return cells.get("%d,%d,%d" % [x, y, z], {})

func _is_valid(x: int, y: int, z: int) -> bool:
	return x >= 0 and x < width and y >= 0 and y < height and z >= 0 and z < depth

func add_fluid(x: int, y: int, z: int, fluid_type: String, amount: int) -> bool:
	var cell = get_cell(x, y, z)
	if cell.is_empty():
		return false
	if cell["fluid_type"] == null:
		cell["fluid_type"] = fluid_type
	cell["amount"] = min(cell["max_amount"], cell["amount"] + amount)
	cell["pressure"] = cell["amount"] / cell["max_amount"]
	cells["%d,%d,%d" % [x, y, z]] = cell
	return true

func remove_fluid(x: int, y: int, z: int, amount: int) -> int:
	var cell = get_cell(x, y, z)
	if cell.is_empty() or cell["fluid_type"] == null:
		return 0
	var removed = min(cell["amount"], amount)
	cell["amount"] -= removed
	cell["pressure"] = cell["amount"] / cell["max_amount"]
	cells["%d,%d,%d" % [x, y, z]] = cell
	return removed

func get_total_fluid(fluid_type: String = "") -> int:
	var total = 0
	for key in cells:
		var cell = cells[key]
		if fluid_type == "" or cell["fluid_type"] == fluid_type:
			total += cell["amount"]
	return total

func get_fluid_distribution() -> Dictionary:
	var distribution = {}
	for key in cells:
		var cell = cells[key]
		if cell["fluid_type"]:
			if cell["fluid_type"] not in distribution:
				distribution[cell["fluid_type"]] = 0
			distribution[cell["fluid_type"]] += cell["amount"]
	return distribution
