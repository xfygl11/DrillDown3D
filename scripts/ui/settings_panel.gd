# 设置面板 - 游戏设置
extends CanvasLayer

class_name SettingsPanel

@onready var music_slider: HSlider = $Panel/VBox/MusicSlider
@onready var sfx_slider: HSlider = $Panel/VBox/SFXSlider
@onready var volume_label: Label = $Panel/VBox/VolumeLabel
@onready var back_btn: Button = $Panel/VBox/BackBtn
@onready var fullscreen_btn: Button = $Panel/VBox/FullscreenBtn

func _ready() -> void:
	music_slider.value_changed.connect(_on_music_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)
	back_btn.pressed.connect(_on_back)
	fullscreen_btn.pressed.connect(_on_fullscreen)

func _on_music_changed(value: float) -> void:
	volume_label.text = "Music: %.0f%%" % (value * 100)
	AudioManager.set_music_volume(value)

func _on_sfx_changed(value: float) -> void:
	volume_label.text = "SFX: %.0f%%" % (value * 100)
	AudioManager.set_sfx_volume(value)

func _on_back() -> void:
	visible = false
	get_viewport().set_input_as_handled()

func _on_fullscreen() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		fullscreen_btn.text = "Windowed"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		fullscreen_btn.text = "Fullscreen"

func show() -> void:
	visible = true
	get_viewport().set_input_as_handled()

func hide() -> void:
	visible = false
