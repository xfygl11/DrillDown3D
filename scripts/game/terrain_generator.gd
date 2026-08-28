# 地形生成器 - 使用噪声算法生成3D地形
extends Node

class_name TerrainGenerator

var seed: int = 42
var scale: float = 0.05
var octaves: int = 4
var persistence: float = 0.5
var lacunarity: float = 2.0

func generate_terrain(width: int, height: int, depth: int) -> Array:
	var terrain = []
	terrain.resize(width)
	for x in range(width):
		terrain[x].resize(height)
		for y in range(height):
			terrain[x][y] = _generate_column(x, y, depth)
	return terrain

func _generate_column(x: int, y: int, depth: int) -> Array:
	var column = []
	for z in range(depth):
		var n = _noise(x * scale, y * scale, z * scale)
		var tile_type = _get_tile_type(n, z, depth)
		column.append({
			"x": x, "y": y, "z": z,
			"type": tile_type,
			"density": 1.0
		})
	return column

func _get_tile_type(noise: float, z: int, depth: int) -> int:
	if z == 0:
		return 2 if noise > 0.3 else 1  # 泥土或石头
	elif z < 5:
		return 1  # 石头层
	elif noise > 0.6 and z > 10:
		return 20  # 铁矿
	elif noise > 0.7 and z > 15:
		return 21  # 煤矿
	elif noise > 0.65 and z > 12:
		return 22  # 铜矿
	else:
		return 0  # 空气

func _noise(x: float, y: float, z: float) -> float:
	var value = 0.0
	var amplitude = 1.0
	var frequency = 1.0
	
	for i in range(octaves):
		value += _perlin(x * frequency, y * frequency, z * frequency) * amplitude
		amplitude *= persistence
		frequency *= lacunarity
	
	return value

func _perlin(x: float, y: float, z: float) -> float:
	# 简化版Perlin噪声
	var ix = int(x) & 255
	var iy = int(y) & 255
	var iz = int(z) & 255
	return (hash(ix * 31337 + iy * 17 + iz) % 1000) / 1000.0 - 0.5
