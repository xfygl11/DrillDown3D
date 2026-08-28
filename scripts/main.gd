# Main - 游戏主入口
# 整合所有系统
extends Node

var game_manager: GameManager = null
var world_grid: Node = null
var hud: Control = null
var game_time: float = 0.0
var is_running: bool = false
const SEPARATOR: String = "============================================================"

func _ready() -> void:
	# 初始化系统
	_init_systems()
	# 获取HUD引用
	hud = get_node("GameHUD")
	# 显示主菜单
	_show_main_menu()

func _init_systems() -> void:
	print(SEPARATOR)
	print("  DrillDown 3D Godot - 游戏初始化")
	print(SEPARATOR)
	
	# 创建 GameManager (从autoload获取)
	game_manager = get_node("/root/GameManager")
	if game_manager == null:
		game_manager = load("res://scripts/core/game_manager.gd").new()
		add_child(game_manager)
	
	# 创建 WorldGrid
	world_grid = load("res://scripts/game/world_grid.gd").new(32, 32, 30)
	add_child(world_grid)
	
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
	# 隐藏主菜单，显示游戏界面
	_hide_main_menu()
	_show_game_ui()
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
	# 返回主菜单
	_show_main_menu()
	_hide_game_ui()
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

# 界面控制函数
func _show_main_menu() -> void:
	# 显示主菜单节点
	var ui_container = get_node("UIContainer")
	if ui_container:
		ui_container.visible = true
	print("[Main] 显示主菜单")

func _hide_main_menu() -> void:
	var ui_container = get_node("UIContainer")
	if ui_container:
		ui_container.visible = false
	print("[Main] 隐藏主菜单")

func _show_game_ui() -> void:
	# 显示HUD（已在场景中）
	if hud:
		hud.visible = true
		# 初始化HUD显示初始数据
		if game_manager:
			hud.update_resources(game_manager.resources)
			hud.update_time(game_manager.game_day, game_manager.game_time)
	print("[Main] 显示游戏界面")

func _hide_game_ui() -> void:
	if hud:
		hud.visible = false
	print("[Main] 隐藏游戏界面")

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
