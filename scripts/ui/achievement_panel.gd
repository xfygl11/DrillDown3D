# 成就面板
extends CanvasLayer

class_name AchievementPanel

@onready var achievement_list: VBoxContainer = $Panel/VBox/AchievementList
@onready var progress_label: Label = $Panel/VBox/ProgressLabel

var achievement_system: AchievementSystem = null

func _ready() -> void:
	achievement_system = get_node("/root/AchievementSystem")
	_setup_achievement_list()

func _setup_achievement_list() -> void:
	if not achievement_system:
		return
	for achievement_id in achievement_system.achievements:
		var achievement = achievement_system.achievements[achievement_id]
		var h_box = HBoxContainer.new()
		
		var icon = Label.new()
		icon.text = "🔓" if achievement["unlocked"] else "🔒"
		
		var info = VBoxContainer.new()
		var name_label = Label.new()
		name_label.text = achievement["name"]
		var desc_label = Label.new()
		desc_label.text = achievement["description"]
		desc_label.modulate.a = 0.7
		info.add_child(name_label)
		info.add_child(desc_label)
		
		h_box.add_child(icon)
		h_box.add_child(info)
		achievement_list.add_child(h_box)
	
	_update_progress()

func _update_progress() -> void:
	if not achievement_system:
		return
	var unlocked = achievement_system.get_unlocked_count()
	var total = achievement_system.get_total_count()
	progress_label.text = "Progress: %d/%d" % [unlocked, total]

func show_panel() -> void:
	visible = true
	_update_progress()

func hide_panel() -> void:
	visible = false
