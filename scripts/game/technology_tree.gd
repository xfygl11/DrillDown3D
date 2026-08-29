# 科技树 - 研究解锁系统
extends Node

class_name TechnologyTree

signal technology_unlocked(tech_id: String)
signal research_complete(tech_id: String)

var technologies: Dictionary = {
	"mining_1": {
		"name": "Basic Mining",
		"description": "Unlock basic stone mining",
		"cost": {"stone": 100},
		"prerequisites": [],
		"unlocked": true
	},
	"mining_2": {
		"name": "Iron Mining",
		"description": "Unlock iron ore mining",
		"cost": {"stone": 200, "iron_ore": 50},
		"prerequisites": ["mining_1"],
		"unlocked": false
	},
	"power_1": {
		"name": "Steam Power",
		"description": "Unlock steam engines",
		"cost": {"stone": 300, "iron_ore": 100},
		"prerequisites": ["mining_2"],
		"unlocked": false
	},
	"power_2": {
		"name": "Electricity",
		"description": "Unlock electric machines",
		"cost": {"copper_ingot": 50, "steel_ingot": 20},
		"prerequisites": ["power_1"],
		"unlocked": false
	},
	"logistics_1": {
		"name": "Conveyor Belts",
		"description": "Unlock automated transport",
		"cost": {"stone": 150, "iron_ingot": 30},
		"prerequisites": ["mining_1"],
		"unlocked": false
	}
}

var research_progress: Dictionary = {}

func get_technologies() -> Dictionary:
	return technologies

func can_research(tech_id: String) -> bool:
	if not tech_id in technologies:
		return false
	var tech = technologies[tech_id]
	if tech["unlocked"]:
		return false
	
	# 检查前置科技
	for prereq in tech["prerequisites"]:
		if not technologies.get(prereq, {}).get("unlocked", false):
			return false
	
	# 检查资源
	var gm = get_node("/root/GameManager")
	for resource in tech["cost"]:
		var current = 0
		if gm:
			current = gm.resources.get(resource, 0)
		if current < tech["cost"][resource]:
			return false
	
	return true

func start_research(tech_id: String) -> bool:
	if not can_research(tech_id):
		return false
	
	# 扣除资源
	var tech = technologies[tech_id]
	var gm = get_node("/root/GameManager")
	for resource in tech["cost"]:
		if gm:
			gm.remove_resource(resource, tech["cost"][resource])
	
	research_progress[tech_id] = 0.0
	print("[Tech] 开始研究: %s" % tech["name"])
	return true

func _process(delta: float) -> void:
	for tech_id in research_progress:
		if not technologies.get(tech_id, {}).get("unlocked", false):
			research_progress[tech_id] = min(100.0, research_progress[tech_id] + delta * 10)
			if research_progress[tech_id] >= 100.0:
				_complete_research(tech_id)

func _complete_research(tech_id: String) -> void:
	technologies[tech_id]["unlocked"] = true
	research_progress.erase(tech_id)
	technology_unlocked.emit(tech_id)
	research_complete.emit(tech_id)
	print("[Tech] 研究完成: %s" % technologies[tech_id]["name"])

func is_researching(tech_id: String) -> bool:
	return tech_id in research_progress

func get_research_progress(tech_id: String) -> float:
	return research_progress.get(tech_id, 0.0)

func get_unlocked_technologies() -> Array:
	var unlocked = []
	for tech_id in technologies:
		if technologies[tech_id]["unlocked"]:
			unlocked.append(tech_id)
	return unlocked
