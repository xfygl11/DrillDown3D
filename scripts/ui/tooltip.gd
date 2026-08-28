# 工具提示 - 悬停信息
extends Control

class_name Tooltip

@onready var title_label: Label = $Title
@onready var desc_label: RichTextLabel = $Description

var current_target: Node = null

func display(target: Node, title: String, description: String) -> void:
	current_target = target
	title_label.text = title
	desc_label.text = description
	visible = true
	position = target.global_position + Vector2(20, -10)

func hide_tooltip() -> void:
	current_target = null
	visible = false

func _process(delta: float) -> void:
	if current_target and visible:
		position = current_target.global_position + Vector2(20, -10)
