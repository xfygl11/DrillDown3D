# DynamicMixing - 动态混音系统
# 对应文档 4.2 动态混音
extends Node

class_name DynamicMixing

var base_ambience: float = 0.3
var industry_ambience: float = 0.5
var current_industry_intensity: float = 0.0

func _ready() -> void:
	# 初始化音频混音器
	print("[DynamicMixing] 动态混音系统初始化完成")

func update_mix(industry_intensity: float) -> void:
	# 根据工业区密度调整环境音
	current_industry_intensity = clamp(industry_intensity, 0.0, 1.0)
	
	var ambience = base_ambience + current_industry_intensity * industry_ambience
	# Godot 4 使用 AudioServer.set_bus_volume_db
	var bus_index = AudioServer.get_bus_index("Master")
	if bus_index >= 0:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(ambience))
	
	print("[DynamicMixing] 环境音量: %.2f, 工业强度: %.2f" % [ambience, current_industry_intensity])

func crossfade_music(from_track: String, to_track: String, duration: float) -> void:
	# 音乐淡入淡出
	print("[DynamicMixing] 音乐切换: %s -> %s (%.1fs)" % [from_track, to_track, duration])

func play_ambience(track: String, loop: bool = true) -> void:
	# 播放环境音
	print("[DynamicMixing] 播放环境音: %s" % track)

func pause_all_audio() -> void:
	# 暂停所有音频
	AudioServer.set_master_volume_db(db_to_linear(0.0))

func resume_all_audio() -> void:
	# 恢复所有音频
	AudioServer.set_master_volume_db(db_to_linear(1.0))
