# 音频管理器 - 管理所有音效和音乐
extends Node

class_name AudioManager

const SFX_PATHS = {
	"click": "res://audio/sfx/click.ogg",
	"build": "res://audio/sfx/build.ogg",
	"mine": "res://audio/sfx/mine.ogg",
	"error": "res://audio/sfx/error.ogg",
	"success": "res://audio/sfx/success.ogg"
}

var music_volume: float = 0.5
var sfx_volume: float = 0.7
var master_volume: float = 1.0

var _sfx_bus: int
var _music_bus: int
var _master_bus: int

func _ready() -> void:
	_setup_buses()

func _setup_buses() -> void:
	_sfx_bus = AudioServer.get_bus_index("SFX")
	_music_bus = AudioServer.get_bus_index("Music")
	_master_bus = AudioServer.get_bus_index("Master")
	_update_volumes()

func _update_volumes() -> void:
	if _sfx_bus >= 0:
		AudioServer.set_bus_volume_db(_sfx_bus, linear_to_db(sfx_volume))
	if _music_bus >= 0:
		AudioServer.set_bus_volume_db(_music_bus, linear_to_db(music_volume))
	if _master_bus >= 0:
		AudioServer.set_bus_volume_db(_master_bus, linear_to_db(master_volume))

func play_sfx(effect: String) -> void:
	if effect in SFX_PATHS:
		var sound = AudioStreamPlayer.new()
		sound.stream = load(SFX_PATHS[effect])
		add_child(sound)
		sound.play()
		sound.finished.connect(func(): queue_free())
	else:
		print("[Audio] 音效未找到: %s" % effect)

func play_build() -> void:
	play_sfx("build")

func play_mine() -> void:
	play_sfx("mine")

func play_click() -> void:
	play_sfx("click")

func play_error() -> void:
	play_sfx("error")

func play_success() -> void:
	play_sfx("success")

static func set_music_volume(value: float) -> void:
	AudioManager.instance.music_volume = value
	AudioManager.instance._update_volumes()

static func set_sfx_volume(value: float) -> void:
	AudioManager.instance.sfx_volume = value
	AudioManager.instance._update_volumes()
