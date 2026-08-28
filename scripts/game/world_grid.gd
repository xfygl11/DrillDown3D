# WorldGrid - 三维世界网格
# 对应 Python WorldGrid.py
extends Node

class_name WorldGrid

# 瓦片类型常量
const AIR = 0
const STONE = 1
const DIRT = 2
const CLAY = 3
const IRON_ORE = 20
const COAL_ORE = 21
const COPPER_ORE = 22
const TIN_ORE = 25
const CRUDE_OIL = 50

var width: int = 64
var height: int = 64
var depth: int = 50
var tiles: Array = []

func _init(w: int = 64, h: int = 64, d: int = 50) -> void:
	width = w
	height = h
	depth = d
	_initialize()

func _initialize() -> void:
	tiles.resize(width)
	for x in range(width):
		tiles[x].resize(height)
		for y in range(height):
			tiles[x][y].resize(depth)
			for z in range(depth):
				tiles[x][y][z] = _create_tile(x, y, z, AIR)
	
	# 初始化地表层
	for x in range(width):
		for y in range(height):
			var tile_type = STONE if randf() < 0.3 else DIRT
			tiles[x][y][0] = _create_tile(x, y, 0, tile_type)

func _create_tile(x: int, y: int, z: int, tile_type: int) -> Dictionary:
	return {
		"x": x,
		"y": y,
		"z": z,
		"type": tile_type,
		"meta": 0,
		"density": 1.0
	}

func get_tile(x: int, y: int, z: int) -> Dictionary:
	if not _is_valid_position(x, y, z):
		return {}
	return tiles[x][y][z]

func set_tile(x: int, y: int, z: int, tile: Dictionary) -> bool:
	if not _is_valid_position(x, y, z):
		return false
	tiles[x][y][z] = tile
	return true

func remove_tile(x: int, y: int, z: int) -> bool:
	if not _is_valid_position(x, y, z):
		return false
	tiles[x][y][z] = _create_tile(x, y, z, AIR)
	return true

func _is_valid_position(x: int, y: int, z: int) -> bool:
	return x >= 0 and x < width and y >= 0 and y < height and z >= 0 and z < depth

func count_tiles_of_type(tile_type: int) -> int:
	var count = 0
	for x in range(width):
		for y in range(height):
			for z in range(depth):
				if tiles[x][y][z]["type"] == tile_type:
					count += 1
	return count

func get_surface_tiles() -> Array:
	var surface_tiles = []
	for x in range(width):
		for y in range(height):
			var tile = get_tile(x, y, 0)
			if tile and tile["type"] != AIR:
				surface_tiles.append(tile)
	return surface_tiles
