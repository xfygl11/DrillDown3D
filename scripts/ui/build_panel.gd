# 建筑面板 - 选择要放置的建筑
extends PanelContainer

class_name BuildPanel

signal building_selected(type: String)

@onready var building_grid: GridContainer = $VBox/BuildingGrid
@onready var selected_label: Label = $VBox/SelectedLabel

var selected_building: String = ""
var audio_manager: AudioManager = null

const BUILDING_TYPES = [
	{"name": "ShaftDrill", "icon": "🔨", "cost": {"stone": 10}},
	{"name": "Furnace", "icon": "🔥", "cost": {"stone": 20, "iron_ore": 5}},
	{"name": "Conveyor", "icon": "➡️", "cost": {"stone": 5}},
	{"name": "Storage", "icon": "📦", "cost": {"stone": 15}},
	{"name": "Boiler", "icon": "♨️", "cost": {"stone": 30, "iron_ore": 10}},
	{"name": "Turbine", "icon": "⚡", "cost": {"steel_ingot": 5, "copper_ingot": 5}}
]

func _ready() -> void:
	audio_manager = get_node("/root/AudioManager")
	_setup_build_buttons()

func _setup_build_buttons() -> void:
	for building in BUILDING_TYPES:
		var btn = Button.new()
		btn.text = "%s %s" % [building["icon"], building["name"]]
		btn.pressed.connect(_on_building_selected.bind(building["name"]))
		building_grid.add_child(btn)

func _on_building_selected(building_type: String) -> void:
	selected_building = building_type
	selected_label.text = "Selected: %s" % building_type
	building_selected.emit(building_type)
	if audio_manager:
		audio_manager.play_click()

func is_building_selected() -> bool:
	return selected_building != ""

func get_selected_building() -> String:
	return selected_building
