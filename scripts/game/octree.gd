# Octree - 八叉树空间划分系统
# 对应文档 2.1.2 空间划分
extends Node

class_name Octree

const MAX_PER_CHUNK = 16
const MAX_DEPTH = 5

var bounds: AABB
var chunks: Array = []
var children: Array = []
var depth: int = 0

func _init(center: Vector3, size: float, depth_level: int = 0) -> void:
	bounds = AABB(center - Vector3(size/2, size/2, size/2), Vector3(size, size, size))
	depth = depth_level

func insert(chunk) -> bool:
	# 插入区块到八叉树
	if not bounds.intersects(chunk.bounds):
		return false
	
	if children.size() == 0:
		# 叶节点
		chunks.append(chunk)
		if chunks.size() > MAX_PER_CHUNK:
			_subdivide()
		return true
	else:
		# 递归插入子节点
		for child in children:
			if child != null and child.insert(chunk):
				return true
		return false

func _subdivide() -> void:
	# 将当前节点细分为8个子节点
	children.resize(8)
	var half_size = bounds.size / 2.0
	
	for x in range(2):
		for y in range(2):
			for z in range(2):
				var child_center = bounds.position + bounds.size * Vector3(
					0.25 + x * 0.5,
					0.25 + y * 0.5,
					0.25 + z * 0.5
				)
				children[x * 4 + y * 2 + z] = Octree.new(child_center, half_size, depth + 1)
	
	# 重新分配区块
	var temp_chunks = chunks.duplicate()
	chunks.clear()
	
	for chunk in temp_chunks:
		for child in children:
			if child != null and child.insert(chunk):
				break

func query(aabb: AABB, result: Array = []) -> Array:
	# 查询与给定边界框相交的所有区块
	if not bounds.intersects(aabb):
		return result
	
	if children.size() == 0:
		for chunk in chunks:
			if aabb.intersects(chunk.bounds):
				result.append(chunk)
		return result
	
	for child in children:
		if child != null:
			child.query(aabb, result)
	
	return result

func get_nearby_chunks(center: Vector3, radius: float) -> Array:
	# 获取指定范围内的所有区块
	var query_aabb = AABB(
		center - Vector3(radius, radius, radius),
		Vector3(radius * 2, radius * 2, radius * 2)
	)
	return query(query_aabb)

func remove(chunk) -> bool:
	# 从八叉树中移除区块
	if children.size() == 0:
		if chunk in chunks:
			chunks.erase(chunk)
			return true
		return false
	else:
		for child in children:
			if child != null and child.remove(chunk):
				return true
		return false

func build_from_chunks(all_chunks: Array) -> void:
	# 从区块列表构建八叉树
	for chunk in all_chunks:
		insert(chunk)

func get_stats() -> Dictionary:
	# 获取八叉树统计信息
	return {
		"depth": depth,
		"chunk_count": _count_chunks(),
		"node_count": _count_nodes(),
		"bounds": bounds
	}

func _count_chunks() -> int:
	var count = chunks.size()
	for child in children:
		if child != null:
			count += child._count_chunks()
	return count

func _count_nodes() -> int:
	var count = 1
	for child in children:
		if child != null:
			count += child._count_nodes()
	return count
