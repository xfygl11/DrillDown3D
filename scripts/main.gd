# Main - 游戏主入口
# 整合所有系统
extends Control

var game_manager: Node = null
var world_grid: Node = null
var hud: Control = null
var game_scene: Node = null
var is_running: bool = false
const SEPARATOR: String = "============================================================"

func _ready() -> void:
	# 初始化系统
	_init_systems()
	# 连接按钮信号
	_connect_buttons()
	# 确保菜单可见
	_show_main_menu()

func _init_systems() -> void:
	print(SEPARATOR)
	print("  DrillDown 3D Godot - 游戏初始化")
	print(SEPARATOR)
	
	# 从autoload获取GameManager
	game_manager = get_node("/root/GameManager")
	if game_manager == null:
		print("[Main] 错误: 无法找到GameManager!")
	else:
		print("[Main] 找到GameManager单例")
	
	print("[Main] 游戏初始化完成")

func _process(delta: float) -> void:
	if not is_running:
		return
	
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
	# 隐藏主菜单
	_hide_main_menu()
	# 加载游戏场景
	_load_game_scene()
	print("🎮 游戏开始！")

func _load_game_scene() -> void:
	# 卸载当前场景的UI
	if hud:
		hud.visible = false
	
	# 创建3D游戏场景
	var game_world_node = Node3D.new()
	game_world_node.name = "GameWorld"
	add_child(game_world_node)
	
	# 添加相机
	var camera = Camera3D.new()
	camera.name = "Camera3D"
	camera.position = Vector3(0, 20, 20)
	camera.rotation = Vector3(-0.5, 0, 0)
	game_world_node.add_child(camera)
	
	# 添加光源
	var light = DirectionalLight3D.new()
	light.name = "DirectionalLight3D"
	light.position = Vector3(0, 20, 0)
	light.rotation = Vector3(0.5, 0.3, 0)
	light.shadow_enabled = true
	game_world_node.add_child(light)
	
	# 添加世界网格
	world_grid = load("res://scripts/game/world_grid.gd").new(32, 32, 30)
	world_grid.name = "WorldGrid"
	game_world_node.add_child(world_grid)
	
	# 创建游戏HUD
	_create_game_hud(game_world_node)
	
	print("[Main] 游戏场景加载完成")

func _create_game_hud(parent: Node) -> void:
	var game_hud = CanvasLayer.new()
	game_hud.name = "GameHUD"
	parent.add_child(game_hud)
	
	# 资源标签
	var resource_label = Label.new()
	resource_label.name = "ResourceLabel"
	resource_label.position = Vector2(10, 10)
	resource_label.text = "资源: 石头=0 铁矿=0 铜矿=0 煤矿=0"
	resource_label.theme_override_font_sizes/font_size = 18
	game_hud.add_child(resource_label)
	
	# 电力标签
	var power_label = Label.new()
	power_label.name = "PowerLabel"
	power_label.position = Vector2(10, 40)
	power_label.text = "电力: 0/0 [正常]"
	power_label.theme_override_font_sizes/font_size = 18
	game_hud.add_child(power_label)
	
	# 时间标签
	var time_label = Label.new()
	time_label.name = "TimeLabel"
	time_label.position = Vector2(10, 70)
	time_label.text = "第1天 00:00"
	time_label.theme_override_font_sizes/font_size = 18
	game_hud.add_child(time_label)
	
	# 暂停按钮
	var pause_btn = Button.new()
	pause_btn.name = "PauseBtn"
	pause_btn.position = Vector2(10, 100)
	pause_btn.text = "暂停"
	pause_btn.pressed.connect(_on_pause_pressed)
	game_hud.add_child(pause_btn)
	
	# 保存引用
	hud = game_hud

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
	_hide_game_scene()
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
	# 显示主菜单容器
	var menu_container = get_node("MenuContainer")
	if menu_container:
		menu_container.visible = true
		print("[Main] 显示主菜单")
	else:
		print("[Main] 错误: 找不到 MenuContainer 节点!")

func _hide_main_menu() -> void:
	var menu_container = get_node("MenuContainer")
	if menu_container:
		menu_container.visible = false
		print("[Main] 隐藏主菜单")

func _hide_game_scene() -> void:
	# 隐藏游戏场景
	var game_world = get_node("GameWorld")
	if game_world:
		game_world.visible = false
		print("[Main] 隐藏游戏场景")

func _connect_buttons() -> void:
	# 手动连接按钮信号
	var start_btn = get_node("MenuContainer/StartBtn")
	var settings_btn = get_node("MenuContainer/SettingsBtn")
	var exit_btn = get_node("MenuContainer/ExitBtn")
	
	if start_btn:
		start_btn.pressed.connect(_on_start_pressed)
		print("[Main] 已连接 StartBtn 信号")
	if settings_btn:
		settings_btn.pressed.connect(_on_settings_pressed)
		print("[Main] 已连接 SettingsBtn 信号")
	if exit_btn:
		exit_btn.pressed.connect(_on_exit_pressed)
		print("[Main] 已连接 ExitBtn 信号")

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

func _on_pause_pressed() -> void:
	print("[Main] 暂停按钮被点击")
	pause_game()
