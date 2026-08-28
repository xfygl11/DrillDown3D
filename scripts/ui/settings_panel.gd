# 设置面板
extends CanvasLayer

class_name SettingsPanel

@onready var music_slider: HSlider = $Panel/MusicSlider
@onready var sfx_slider: HSlider = $Panel/SFXSlider
@onready var volume_label: Label = $Panel/VolumeLabel
@onready var back_btn: Button = $Panel/BackBtn

func _ready() -> void:
	music_slider.value_changed.connect(_on_music_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)
	back_btn.pressed.connect(_on_back)

func _on_music_changed(value: float) -> void:
	volume_label.text = "Music: %.0f%%" % (value * 100)
	AudioManager.set_music_volume(value)

func _on_sfx_changed(value: float) -> void:
	volume_label.text = "SFX: %.0f%%" % (value * 100)
	AudioManager.set_sfx_volume(value)

func _on_back() -> void:
	visible = false
	get_viewport().set_input_as_handled()
