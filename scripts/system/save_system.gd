# 存档系统 - 游戏数据存储
extends Node

class_name SaveSystem

const SAVE_PATH = "user://savegame.dat"
const AUTO_SAVE_INTERVAL = 300.0

var auto_save_timer: float = 0.0
var is_autosaving: bool = false

func save_game(data: Dictionary) -> bool:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
		print("[Save] 游戏已保存")
		return true
	print("[Save] 保存失败")
	return false

func load_game() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		print("[Save] 无存档文件")
		return {}
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		print("[Save] 游戏已加载")
		return data if data else {}
	return {}

func auto_save(game_state: Dictionary) -> bool:
	auto_save_timer += 1
	if auto_save_timer >= AUTO_SAVE_INTERVAL:
		auto_save_timer = 0
		is_autosaving = true
		var result = save_game(game_state)
		is_autosaving = false
		return result
	return false

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func get_save_info() -> Dictionary:
	if not has_save():
		return {"exists": false}
	var data = load_game()
	return {
		"exists": true,
		"day": data.get("game_day", 0),
		"time": data.get("game_time", 0),
		"resources": data.get("resources", {})
	}
