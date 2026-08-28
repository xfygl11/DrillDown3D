# Main - 游戏主入口
# 整合所有系统
extends Node

var game_manager: Node
var world_grid: Node
var hud: Node
var game_time: float = 0.0
var is_running: bool = false
const SEPARATOR: String = "============================================================"

func _ready() -> void:
	# 初始化系统
	_init_systems()

func _init_systems() -> void:
	print(SEPARATOR)
	print("  DrillDown 3D Godot - 游戏初始化")
	print(SEPARATOR)
	
	# 创建 GameManager
	game_manager = load("res://scripts/core/game_manager.gd").new()
	add_child(game_manager)
	
	# 创建 WorldGrid
	world_grid = load("res://scripts/game/world_grid.gd").new(32, 32, 30)
	add_child(world_grid)
	
	# 创建 HUD
	hud = load("res://scripts/ui/game_hud.gd").new()
	add_child(hud)
	
	print("[Main] 游戏初始化完成")

func _process(delta: float) -> void:
	if not is_running:
		return
	
	# 更新游戏时间
	game_time += delta
	
	# 更新 GameManager
	if game_manager:
		game_manager.update(delta)
	
	# 更新 HUD
	if hud:
		hud.update_time(game_manager.game_day, game_manager.game_time)
		hud.update_resources(game_manager.resources)

func start_game() -> void:
	if game_manager:
		game_manager.switch_state(GameManager.GameState.PLAYING)
	is_running = true
	print("🎮 游戏开始！")

func pause_game() -> void:
	if game_manager:
		game_manager.switch_state(GameManager.GameState.PAUSED)
	print("⏸ 游戏已暂停")

func resume_game() -> void:
	if game_manager:
		game_manager.switch_state(GameManager.GameState.PLAYING)
	print("▶ 游戏已恢复")

func stop_game() -> void:
	if game_manager:
		game_manager.switch_state(GameManager.GameState.MENU)
	is_running = false
	print("⏹ 游戏已停止")

func place_building(building_type: String, x: int, y: int, z: int) -> bool:
	print("[Main] 放置建筑: %s at (%d, %d, %d)" % [building_type, x, y, z])
	return true

func save_game(filepath: String) -> bool:
	if game_manager:
		return game_manager.save_game(filepath)
	return false

func load_game(filepath: String) -> bool:
	if game_manager:
		return game_manager.load_game(filepath)
	return false

# 按钮回调函数
func _on_start_pressed() -> void:
	print("[Main] 开始游戏按钮被点击")
	start_game()

func _on_settings_pressed() -> void:
	print("[Main] 设置按钮被点击")
	# TODO: 打开设置面板

func _on_exit_pressed() -> void:
	print("[Main] 退出按钮被点击")
	get_tree().quit()
