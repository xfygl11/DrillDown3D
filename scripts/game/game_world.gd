# 游戏世界 - 整合所有系统
extends Node

class_name GameWorld

var world_grid: WorldGrid
var power_network: PowerNetwork
var fluid_grid: FluidGrid
var mining_system: MiningSystem
var crafting_system: CraftingSystem
var buildings: Array = []
var audio_manager: AudioManager = null

func _ready() -> void:
	audio_manager = get_node("/root/AudioManager")
	_initialize_systems()
	_setup_connections()

func _initialize_systems() -> void:
	# 初始化世界网格
	world_grid = WorldGrid.new(64, 64, 50)
	add_child(world_grid)
	
	# 初始化电力系统
	power_network = PowerNetwork.new(1)
	add_child(power_network)
	
	# 初始化流体系统
	fluid_grid = FluidGrid.new(64, 64, 50)
	add_child(fluid_grid)
	
	# 初始化采矿系统
	mining_system = MiningSystem.new()
	add_child(mining_system)
	
	# 初始化合成系统
	crafting_system = CraftingSystem.new()
	add_child(crafting_system)
	
	print("[GameWorld] 游戏世界初始化完成")

func _setup_connections() -> void:
	mining_system.resource_gathered.connect(_on_resource_gathered)
	mining_system.mining_complete.connect(_on_mining_complete)

func _process(delta: float) -> void:
	# 更新电力系统
	power_network.update(delta)
	
	# 更新流体系统
	fluid_grid.update(delta)
	
	# 更新所有建筑
	for building in buildings:
		if building.is_operational and building.is_powered:
			var output = building.produce(delta)
			if not output.is_empty():
				_handle_output(building, output)

func _on_resource_gathered(resource_type: String, amount: int) -> void:
	var gm = get_node("/root/GameManager")
	if gm:
		gm.add_resource(resource_type, amount)
	if audio_manager:
		audio_manager.play_mine()

func _on_mining_complete(tile_type: String) -> void:
	if audio_manager:
		audio_manager.play_success()

func _handle_output(building: Building, output: Dictionary) -> void:
	var gm = get_node("/root/GameManager")
	if gm and output.type in gm.resources:
		gm.add_resource(output.type, output.amount)
	else:
		# 放入最近的存储
		_store_item(building, output)

func _store_item(building: Building, item: Dictionary) -> void:
	for storage in buildings:
		if storage is Storage:
			if storage.can_accept(item):
				storage.accept_item(item)
				return

func add_building(building: Building) -> void:
	buildings.append(building)
	building.on_place()
	print("[GameWorld] 添加建筑: %s at %s" % [building.type, building.position])

func remove_building(building: Building) -> void:
	if building in buildings:
		buildings.erase(building)
		building.on_remove()
		print("[GameWorld] 移除建筑: %s" % building.type)
