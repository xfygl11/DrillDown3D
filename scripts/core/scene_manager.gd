# SceneManager - 场景管理器
# 对应 Python SceneManager.py
extends Node

# 注意：SceneManager 已在 project.godot 中注册为 autoload 单例
# 所以这里不使用 class_name 避免冲突

var _scenes: Dictionary = {}
var _current_scene: String = ""
var _loading: bool = false
var _load_progress: float = 0.0

func register_scene(name: String, scene_data: Dictionary) -> void:
	_scenes[name] = scene_data
	print("[SceneManager] 注册场景: %s" % name)

func load_scene(name: String, additive: bool = false) -> bool:
	if not name in _scenes:
		print("[SceneManager] 场景不存在: %s" % name)
		return false
	
	if _loading:
		print("[SceneManager] 正在加载中，请稍后")
		return false
	
	_loading = true
	_load_progress = 0.0
	print("[SceneManager] 开始加载场景: %s" % name)
	
	# 模拟加载过程
	var scene = _scenes[name]
	_current_scene = name
	_loading = false
	_load_progress = 1.0
	
	print("[SceneManager] 场景加载完成: %s" % name)
	return true

func unload_scene(name: String) -> bool:
	if name == _current_scene:
		_current_scene = ""
		print("[SceneManager] 卸载当前场景: %s" % name)
		return true
	else:
		print("[SceneManager] 场景未加载: %s" % name)
		return false

func get_current_scene() -> String:
	return _current_scene

func get_all_scenes() -> Array:
	return _scenes.keys()
