# TileLOD - 瓦片细节层次系统
# 对应文档 2.1.3 LOD系统
extends Node

class_name TileLOD

# LOD级别
enum LODLevel {
	HIGH = 0,      # 高细节
	MEDIUM = 1,    # 中细节
	LOW = 2        # 低细节
}

var lod_level: int = LODLevel.HIGH
var render_distance: float = 50.0
var chunk_position: Vector3i = Vector3i.ZERO
var chunk_mesh: MeshInstance3D = null

# 每个LOD级别的网格数据
var high_detail_mesh: Array = []
var medium_detail_mesh: Array = []
var low_detail_mesh: Array = []

func _init(pos: Vector3i, dist: float = 50.0) -> void:
	chunk_position = pos
	render_distance = dist
	_setup_lod_levels()

func _setup_lod_levels() -> void:
	# 初始化各LOD级别的网格
	high_detail_mesh = _generate_high_detail_mesh()
	medium_detail_mesh = _generate_medium_detail_mesh()
	low_detail_mesh = _generate_low_detail_mesh()

func _generate_high_detail_mesh() -> Array:
	# 生成高细节网格 (完整8x8x8体素)
	var mesh_data = []
	for x in range(8):
		for y in range(8):
			for z in range(8):
				mesh_data.append(Vector3i(x, y, z))
	return mesh_data

func _generate_medium_detail_mesh() -> Array:
	# 生成中细节网格 (每2个体素合并)
	var mesh_data = []
	for x in range(0, 8, 2):
		for y in range(0, 8, 2):
			for z in range(0, 8, 2):
				mesh_data.append(Vector3i(x, y, z))
	return mesh_data

func _generate_low_detail_mesh() -> Array:
	# 生成低细节网格 (每4个体素合并)
	var mesh_data = []
	for x in range(0, 8, 4):
		for y in range(0, 8, 4):
			for z in range(0, 8, 4):
				mesh_data.append(Vector3i(x, y, z))
	return mesh_data

func update_lod(camera_position: Vector3) -> void:
	# 根据相机距离更新LOD级别
	var distance = camera_position.distance_to(_get_chunk_center())
	var new_lod = _calculate_lod_level(distance)
	
	if new_lod != lod_level:
		_set_lod(new_lod)

func _calculate_lod_level(distance: float) -> int:
	if distance < render_distance * 0.5:
		return LODLevel.HIGH
	elif distance < render_distance:
		return LODLevel.MEDIUM
	else:
		return LODLevel.LOW

func _set_lod(level: int) -> void:
	lod_level = level
	_update_mesh()
	print("[TileLOD] LOD级别切换到: %s" % ["HIGH", "MEDIUM", "LOW"][level])

func _update_mesh() -> void:
	# 根据LOD级别更新渲染网格
	match lod_level:
		LODLevel.HIGH:
			apply_mesh(high_detail_mesh)
		LODLevel.MEDIUM:
			apply_mesh(medium_detail_mesh)
		LODLevel.LOW:
			apply_mesh(low_detail_mesh)

func apply_mesh(mesh_data: Array) -> void:
	# 应用网格数据到渲染器
	if chunk_mesh:
		chunk_mesh.queue_free()
		chunk_mesh = null
	# 实际实现需要创建MeshInstance3D
	# 这里简化处理

func _get_chunk_center() -> Vector3:
	return Vector3(
		chunk_position.x * 8.0 + 4.0,
		chunk_position.y * 8.0 + 4.0,
		chunk_position.z * 8.0 + 4.0
	)

func get_visible_chunks(camera_position: Vector3, max_chunks: int = 64) -> Array:
	# 视锥剔除 - 只返回可见的区块
	var visible = []
	for x in range(-4, 5):
		for y in range(-4, 5):
			for z in range(-4, 5):
				var chunk_pos = chunk_position + Vector3i(x, y, z)
				var dist = camera_position.distance_to(
					Vector3(chunk_pos.x * 8.0, chunk_pos.y * 8.0, chunk_pos.z * 8.0)
				)
				if dist < render_distance:
					visible.append(chunk_pos)
					if visible.size() >= max_chunks:
						return visible
	return visible
