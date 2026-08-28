# GameHUD - 游戏内界面
# 对应 Python GameHUD.py
extends CanvasLayer

class_name GameHUD

var resources: Dictionary = {}
var power_generation: float = 0
var power_consumption: float = 0
var game_day: int = 1
var game_time: float = 0
var is_paused: bool = false
var selected_building: String = ""

# UI节点引用
@onready var resource_label: Label = $ResourceLabel
@onready var power_label: Label = $PowerLabel
@onready var time_label: Label = $TimeLabel
@onready var pause_btn: Button = $PauseBtn

func _ready() -> void:
	# 隐藏HUD直到游戏开始
	visible = false
	_update_all_display()

func update_resources(resources_dict: Dictionary) -> void:
	resources = resources_dict.duplicate()
	_update_resource_display()

func _update_resource_display() -> void:
	var stone = resources.get("stone", 0)
	var iron = resources.get("iron_ore", 0)
	var copper = resources.get("copper_ore", 0)
	var coal = resources.get("coal_ore", 0)
	
	# 更新UI标签
	if resource_label:
		resource_label.text = "资源: 石头=%d 铁矿=%d 铜矿=%d 煤矿=%d" % [stone, iron, copper, coal]
	
	print("[HUD] 资源: 石头=%d, 铁矿=%d, 铜矿=%d, 煤矿=%d" % [stone, iron, copper, coal])

func update_power(generation: float, consumption: float) -> void:
	power_generation = generation
	power_consumption = consumption
	_update_power_display()

func _update_power_display() -> void:
	var status = "正常" if (power_consumption <= power_generation) or (power_generation == 0) else "不足"
	
	# 更新UI标签
	if power_label:
		power_label.text = "电力: %.0f/%.0f [%s]" % [power_generation, power_consumption, status]
	
	print("[HUD] 电力: 发电=%.0f, 消费=%.0f, 状态=%s" % [power_generation, power_consumption, status])

func update_time(day: int, time: float) -> void:
	game_day = day
	game_time = time
	_update_time_display()

func _update_time_display() -> void:
	var hours = int(game_time / 3600.0)
	var minutes = int(fmod(game_time, 3600.0) / 60.0)
	
	# 更新UI标签
	if time_label:
		time_label.text = "第%d天 %02d:%02d" % [game_day, hours, minutes]
	
	print("[HUD] 时间: 第%d天 %02d:%02d" % [game_day, hours, minutes])

func toggle_pause() -> bool:
	is_paused = not is_paused
	if pause_btn:
		pause_btn.text = "继续" if is_paused else "暂停"
	print("[HUD] 游戏%s" % ("暂停" if is_paused else "继续"))
	return is_paused

func select_building(building_id: String) -> void:
	selected_building = building_id
	if building_id != "":
		print("[HUD] 选中建筑: %s" % building_id)
	else:
		print("[HUD] 取消选中")

func get_power_ratio() -> float:
	if power_generation == 0:
		return 0.0
	return power_consumption / power_generation

func is_power_sufficient() -> bool:
	return power_consumption <= power_generation

func _on_pause_btn_pressed() -> void:
	toggle_pause()

func serialize() -> String:
	var data = {
		"resources": resources,
		"power_generation": power_generation,
		"power_consumption": power_consumption,
		"game_day": game_day,
		"game_time": game_time,
		"is_paused": is_paused,
		"selected_building": selected_building
	}
	return JSON.stringify(data)

func deserialize(data_str: String) -> void:
	var data = JSON.parse_string(data_str)
	if data:
		resources = data.get("resources", {})
		power_generation = data.get("power_generation", 0)
		power_consumption = data.get("power_consumption", 0)
		game_day = data.get("game_day", 1)
		game_time = data.get("game_time", 0)
		is_paused = data.get("is_paused", false)
		selected_building = data.get("selected_building", "")

func _update_all_display() -> void:
	_update_resource_display()
	_update_power_display()
	_update_time_display()
