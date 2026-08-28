# 资源面板 - 显示所有资源
extends PanelContainer

class_name ResourcePanel

@onready var resource_list: VBoxContainer = $ResourceList

func _ready() -> void:
	_setup_ui()

func _setup_ui() -> void:
	var resource_types = ["stone", "iron_ore", "coal_ore", "copper_ore", "gold_ore", "steel_ingot", "copper_ingot"]
	for res_type in resource_types:
		var h_box = HBoxContainer.new()
		var label = Label.new()
		label.text = "%s: %d" % [res_type.capitalize(), 0]
		label.name = res_type + "_label"
		h_box.add_child(label)
		resource_list.add_child(h_box)

func update_resources(resources: Dictionary) -> void:
	for child in resource_list.get_children():
		var label = child.get_child(0) as Label
		if label:
			var res_type = label.name.replace("_label", "")
			var count = resources.get(res_type, 0)
			label.text = "%s: %d" % [res_type.capitalize(), count]
