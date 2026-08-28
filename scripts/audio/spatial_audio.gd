# SpatialAudio - 3D空间音频系统
# 对应文档 4.1 3D空间音频
extends Node

class_name SpatialAudio

var audio_players: Dictionary = {}
var max_distance: float = 50.0
var min_distance: float = 2.0

func _ready() -> void:
	_setup_audio_context()

func _setup_audio_context() -> void:
	# 初始化音频上下文
	print("[SpatialAudio] 3D音频系统初始化完成")

func play_3d_sound(sound_name: String, position: Vector3, volume: float = 1.0) -> AudioStreamPlayer3D:
	# 播放3D声音
	var audio_player = AudioStreamPlayer3D.new()
	audio_player.stream = _load_sound_stream(sound_name)
	audio_player.position = position
	audio_player.max_distance = max_distance
	audio_player.min_distance = min_distance
	audio_player.volume_db = linear_to_db(volume)
	audio_player.one_shot = true
	
	add_child(audio_player)
	audio_players[sound_name] = audio_player
	
	audio_player.play()
	print("[SpatialAudio] 播放3D声音: %s at %s" % [sound_name, position])
	
	return audio_player

func _load_sound_stream(sound_name: String) -> AudioStream:
	# 加载音效资源
	var path = "res://assets/audio/sfx/%s.ogg" % sound_name
	if ResourceLoader.exists(path):
		return load(path)
	# 如果没有文件，返回null
	return null

func stop_all_sounds() -> void:
	# 停止所有声音
	for sound_name in audio_players:
		var player = audio_players[sound_name]
		if player and player.playing:
			player.stop()
	audio_players.clear()

func set_master_volume(volume: float) -> void:
	# 设置主音量
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		linear_to_db(volume)
	)

func get_master_volume() -> float:
	# 获取主音量
	return db_to_linear(
		AudioServer.get_bus_volume_db(
			AudioServer.get_bus_index("Master")
		)
	)
