# 城市面板 - 显示城市和人口信息
extends CanvasLayer

class_name CityPanel

@onready var population_label: Label = $Panel/Population
@onready var happiness_label: Label = $Panel/Happiness
@onready var demands_list: VBoxContainer = $Panel/DemandsList

var city_system: CitySystem = null

func _ready() -> void:
	city_system = get_node("/root/CitySystem")

func _process(delta: float) -> void:
	_update_ui()

func _update_ui() -> void:
	if not city_system:
		return
	population_label.text = "Population: %d/%d" % [city_system.population, city_system.max_population]
	happiness_label.text = "Happiness: %.0f%%" % [city_system.happiness]
	_update_demands()

func _update_demands() -> void:
	if not city_system:
		return
	# 清空列表
	for child in demands_list.get_children():
		child.queue_free()
	
	# 添加需求项
	var demands = city_system.demands
	for demand_type in demands:
		var amount = demands[demand_type]
		if amount > 0:
			var h_box = HBoxContainer.new()
			var label = Label.new()
			label.text = "%s: %d" % [demand_type.capitalize(), amount]
			h_box.add_child(label)
			demands_list.add_child(h_box)

func show_panel() -> void:
	visible = true

func hide_panel() -> void:
	visible = false
