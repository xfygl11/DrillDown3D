# 成就面板
extends CanvasLayer

class_name AchievementPanel

@onready var achievement_list: VBoxContainer = $Panel/VBox/AchievementList
@onready var progress_label: Label = $Panel/VBox/ProgressLabel

func _ready() -> void:
	_setup_achievement_list()

func _setup_achievement_list() -> void:
	for achievement_id in AchievementSystem.achievements:
		var achievement = AchievementSystem.achievements[achievement_id]
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
	var unlocked = AchievementSystem.get_unlocked_count()
	var total = AchievementSystem.get_total_count()
	progress_label.text = "Progress: %d/%d" % [unlocked, total]

func show() -> void:
	visible = true
	_update_progress()

func hide() -> void:
	visible = false
