# Main - 游戏主入口
# 整合所有系统
extends Control

var game_manager: Node = null
var world_grid: Node = null
var terrain_generator: Node = null
var game_world_node: Node3D = null
var hud: CanvasLayer = null
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
	# 创建3D游戏世界节点
	game_world_node = Node3D.new()
	game_world_node.name = "GameWorld"
	add_child(game_world_node)
	
	# 添加相机
	var camera = Camera3D.new()
	camera.name = "Camera3D"
	camera.position = Vector3(16, 30, 30)
	game_world_node.add_child(camera)
	# 相机添加到树后再设置朝向
	await get_tree().process_frame
	camera.look_at(Vector3(16, 0, 16))
	
	# 添加光源
	var light = DirectionalLight3D.new()
	light.name = "DirectionalLight3D"
	light.position = Vector3(16, 40, 16)
	light.rotation = Vector3(0.5, 0.3, 0)
	light.shadow_enabled = true
	game_world_node.add_child(light)
	
	# 创建地形生成器
	terrain_generator = TerrainGenerator.new()
	terrain_generator.name = "TerrainGenerator"
	game_world_node.add_child(terrain_generator)
	
	# 创建世界网格
	world_grid = WorldGrid.new(32, 32, 30)
	world_grid.name = "WorldGrid"
	game_world_node.add_child(world_grid)
	
	# 生成地形
	_generate_terrain()
	
	# 创建游戏HUD
	create_game_hud()
	
	print("[Main] 游戏场景加载完成")

func _generate_terrain() -> void:
	if terrain_generator and world_grid:
		print("[Main] 开始生成地形...")
		# 使用TerrainGenerator生成地形数据
		var terrain_data = terrain_generator.generate_terrain(
			world_grid.width,
			world_grid.height,
			world_grid.depth
		)
		
		# 将地形数据写入WorldGrid
		for x in range(world_grid.width):
			for y in range(world_grid.height):
				for z in range(world_grid.depth):
					if z < terrain_data[x][y].size():
						var tile = terrain_data[x][y][z]
						var tile_dict = {
							"x": x,
							"y": y,
							"z": z,
							"type": tile.type,
							"meta": 0,
							"density": tile.density
						}
						world_grid.set_tile(x, y, z, tile_dict)
		
		print("[Main] 地形生成完成")

func create_game_hud() -> void:
	var game_hud = CanvasLayer.new()
	game_hud.name = "GameHUD"
	game_world_node.add_child(game_hud)

	# 创建共享字体主题
	var theme = Theme.new()
	theme.set_font_size("font_size", "Label", 18)

	# 资源标签
	var resource_label = Label.new()
	resource_label.name = "ResourceLabel"
	resource_label.position = Vector2(10, 10)
	resource_label.text = "资源: 石头=0 铁矿=0 铜矿=0 煤矿=0"
	resource_label.theme = theme
	game_hud.add_child(resource_label)

	# 电力标签
	var power_label = Label.new()
	power_label.name = "PowerLabel"
	power_label.position = Vector2(10, 40)
	power_label.text = "电力: 0/0 [正常]"
	power_label.theme = theme
	game_hud.add_child(power_label)

	# 时间标签
	var time_label = Label.new()
	time_label.name = "TimeLabel"
	time_label.position = Vector2(10, 70)
	time_label.text = "第1天 00:00"
	time_label.theme = theme
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
	var menu_container = get_node("MenuContainer")
	if menu_container:
		menu_container.visible = true
		print("[Main] 显示主菜单")

func _hide_main_menu() -> void:
	var menu_container = get_node("MenuContainer")
	if menu_container:
		menu_container.visible = false
		print("[Main] 隐藏主菜单")

func _hide_game_scene() -> void:
	if game_world_node:
		game_world_node.visible = false
		print("[Main] 隐藏游戏场景")

func _connect_buttons() -> void:
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

func _on_exit_pressed() -> void:
	print("[Main] 退出按钮被点击")
	get_tree().quit()

func _on_pause_pressed() -> void:
	print("[Main] 暂停按钮被点击")
	pause_game()
