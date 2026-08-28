# 成就系统
extends Node

class_name AchievementSystem

signal achievement_unlocked(achievement_id: String)

var achievements: Dictionary = {
	"first_mine": {
		"name": "First Step",
		"description": "Mine your first stone",
		"unlocked": false,
		"condition": func(resources): return resources.get("stone", 0) >= 1
	},
	"industrialist": {
		"name": "Industrialist",
		"description": "Build 10 factories",
		"unlocked": false,
		"condition": func(buildings): return buildings >= 10
	},
	"millionaire": {
		"name": "Millionaire",
		"description": "Accumulate 1M resources",
		"unlocked": false,
		"condition": func(resources): return resources.get("stone", 0) >= 1000000
	},
	"electric_age": {
		"name": "Electric Age",
		"description": "Unlock electricity",
		"unlocked": false,
		"condition": func(): return _check_electric_age()
	}
}

var audio_manager: AudioManager = null
var tech_tree: TechnologyTree = null

func _ready() -> void:
	audio_manager = get_node("/root/AudioManager")
	tech_tree = get_node("/root/TechnologyTree")

func check_achievement(achievement_id: String) -> bool:
	if achievement_id not in achievements:
		return false
	var achievement = achievements[achievement_id]
	if achievement["unlocked"]:
		return false
	
	var result = achievement["condition"].call()
	if result:
		achievement["unlocked"] = true
		achievement_unlocked.emit(achievement_id)
		print("[Achievement] 成就解锁: %s" % achievement["name"])
		if audio_manager:
			audio_manager.play_success()
		return true
	return false

func _check_electric_age() -> bool:
	if tech_tree:
		return tech_tree.get_technologies().get("power_2", {}).get("unlocked", false)
	return false

func check_all_achievements(data: Dictionary) -> void:
	for achievement_id in achievements:
		check_achievement(achievement_id)

func get_unlocked_count() -> int:
	var count = 0
	for achievement in achievements.values():
		if achievement["unlocked"]:
			count += 1
	return count

func get_total_count() -> int:
	return achievements.size()
