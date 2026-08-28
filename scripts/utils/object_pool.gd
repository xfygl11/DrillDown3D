# ObjectPool - 对象池
# 对应 Python ObjectPool.py
extends Node

class_name ObjectPool

var _factory: Callable
var _max_size: int
var _pool: Array = []
var _active_count: int = 0

func _init(factory: Callable, max_size: int = 100) -> void:
	_factory = factory
	_max_size = max_size

func get() -> Variant:
	if _pool.size() > 0:
		var obj = _pool.pop_back()
		_active_count += 1
		return obj
	
	if _active_count < _max_size:
		var obj = _factory.call()
		_active_count += 1
		return obj
	
	return null

func release(obj: Variant) -> void:
	if _pool.size() < _max_size:
		_pool.append(obj)
	_active_count -= 1

@property
var size() -> int:
	return _pool.size()

@property
var active_count() -> int:
	return _active_count

@property
var total_count() -> int:
	return _pool.size() + _active_count
