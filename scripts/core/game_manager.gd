# GameManager - 游戏状态管理器
# 对应 Python GameManager.py
extends Node

# 注意：GameManager 已在 project.godot 中注册为 autoload 单例
# 所以这里不使用 class_name 避免冲突

enum GameState {
	MENU,
	PLAYING,
	PAUSED,
	GAME_OVER
}

var state: GameState = GameState.MENU
var resources: Dictionary = {
	"stone": 0,
	"iron_ore": 0,
	"copper_ore": 0,
	"coal_ore": 0,
	"steel_ingot": 0,
	"copper_ingot": 0
}
var game_time: float = 0.0
var game_day: int = 1
var game_speed: int = 1

func _ready() -> void:
	pass

func switch_state(new_state: GameState) -> void:
	var old_state = state
	state = new_state
	print("[GameManager] 状态切换: %s -> %s" % [old_state, new_state])

func add_resource(resource_type: String, amount: int) -> bool:
	if resource_type in resources:
		resources[resource_type] += amount
		print("[GameManager] 资源增加: %s +%d = %d" % [resource_type, amount, resources[resource_type]])
		return true
	return false

func remove_resource(resource_type: String, amount: int) -> bool:
	if resource_type in resources and resources[resource_type] >= amount:
		resources[resource_type] -= amount
		print("[GameManager] 资源消耗: %s -%d = %d" % [resource_type, amount, resources[resource_type]])
		return true
	print("[GameManager] 资源不足: %s 需要 %d, 拥有 %d" % [resource_type, amount, resources.get(resource_type, 0)])
	return false

func update(delta: float) -> void:
	if state != GameState.PLAYING:
		return
	
	game_time += delta * game_speed
	
	# 每天60秒
	if game_time >= 60.0:
		game_time -= 60.0
		game_day += 1
		print("[GameManager] 新的一天开始: Day %d" % game_day)

func save_game(filepath: String) -> bool:
	var data = {
		"state": state,
		"resources": resources,
		"game_time": game_time,
		"game_day": game_day,
		"game_speed": game_speed
	}
	var file = FileAccess.open(filepath, FileAccess.WRITE)
	if file:
		file.store_line(JSON.stringify(data))
		file.close()
		print("[GameManager] 游戏已保存到: %s" % filepath)
		return true
	print("[GameManager] 保存失败")
	return false

func load_game(filepath: String) -> bool:
	if not FileAccess.file_exists(filepath):
		print("[GameManager] 存档文件不存在: %s" % filepath)
		return false
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file:
		var line = file.get_line()
		var data = JSON.parse_string(line)
		if data:
			state = data.get("state", GameState.MENU)
			resources = data.get("resources", resources)
			game_time = data.get("game_time", 0.0)
			game_day = data.get("game_day", 1)
			game_speed = data.get("game_speed", 1)
			print("[GameManager] 游戏已从 %s 加载" % filepath)
			return true
	file.close()
	return false
