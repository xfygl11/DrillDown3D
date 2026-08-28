# 城市面板 - 显示城市和人口信息
extends CanvasLayer

class_name CityPanel

@onready var population_label: Label = $Panel/Population
@onready var happiness_label: Label = $Panel/Happiness
@onready var demands_list: VBoxContainer = $Panel/DemandsList

func _process(delta: float) -> void:
	_update_ui()

func _update_ui() -> void:
	population_label.text = "Population: %d/%d" % [int(CitySystem.population), CitySystem.max_population]
	happiness_label.text = "Happiness: %.0f%%" % CitySystem.happiness
	_update_demands()

func _update_demands() -> void:
	# 清空列表
	for child in demands_list.get_children():
		child.queue_free()
	
	# 添加需求项
	for demand_type in CitySystem.demands:
		var amount = CitySystem.demands[demand_type]
		if amount > 0:
			var h_box = HBoxContainer.new()
			var label = Label.new()
			label.text = "%s: %d" % [demand_type.capitalize(), amount]
			h_box.add_child(label)
			demands_list.add_child(h_box)

func show() -> void:
	visible = true

func hide() -> void:
	visible = false
