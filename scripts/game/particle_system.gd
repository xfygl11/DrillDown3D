# ParticleSystem - 粒子特效系统
# 对应文档 3.3 粒子特效清单
extends Node

class_name ParticleSystem

# 粒子类型常量
const PARTICLE_TYPES = {
	"steam": {
		"name": "蒸汽",
		"particle_count": 50,
		"duration": 2.0,
		"color": Color(0.8, 0.8, 0.8, 0.5),
		"speed": Vector3(0, 2, 0),
		"size": Vector2(0.5, 0.5)
	},
	"fire": {
		"name": "火焰",
		"particle_count": 100,
		"duration": 1.0,
		"color": Color(1, 0.5, 0, 1),
		"speed": Vector3(0, 3, 0),
		"size": Vector2(0.3, 0.3)
	},
	"smoke": {
		"name": "烟雾",
		"particle_count": 30,
		"duration": 3.0,
		"color": Color(0.3, 0.3, 0.3, 0.6),
		"speed": Vector3(0, 1, 0),
		"size": Vector2(1.0, 1.0)
	},
	"sparks": {
		"name": "火花",
		"particle_count": 20,
		"duration": 0.5,
		"color": Color(1, 1, 0, 1),
		"speed": Vector3(0, 5, 0),
		"size": Vector2(0.1, 0.1)
	},
	"dust": {
		"name": "灰尘",
		"particle_count": 40,
		"duration": 1.0,
		"color": Color(0.7, 0.6, 0.5, 0.8),
		"speed": Vector3(0, 1, 0),
		"size": Vector2(0.2, 0.2)
	},
	"liquid_flow": {
		"name": "流体流动",
		"particle_count": 60,
		"duration": 2.0,
		"color": Color(0, 0.5, 1, 0.6),
		"speed": Vector3(0, 0, 2),
		"size": Vector2(0.3, 0.3)
	},
	"electric_arc": {
		"name": "电弧",
		"particle_count": 15,
		"duration": 0.3,
		"color": Color(0.5, 0.5, 1, 1),
		"speed": Vector3(0, 0, 0),
		"size": Vector2(0.1, 0.1)
	},
	"confetti": {
		"name": "彩纸",
		"particle_count": 100,
		"duration": 3.0,
		"color": Color(1, 1, 1, 1),
		"speed": Vector3(0, 5, 0),
		"size": Vector2(0.2, 0.2)
	}
}

var active_particles: Dictionary = {}

func spawn_particle(type: String, position: Vector3, custom_params: Dictionary = {}) -> void:
	# 生成粒子特效
	var params = PARTICLE_TYPES.get(type, PARTICLE_TYPES["dust"]).duplicate(true)
	params.merge(custom_params)
	
	var particle_id = str(position) + "_" + type + "_" + str(Time.get_ticks_msec())
	active_particles[particle_id] = {
		"type": type,
		"position": position,
		"params": params,
		"spawn_time": Time.get_ticks_msec(),
		"lifetime": params.duration
	}
	
	print("[ParticleSystem] 生成粒子: %s at %s" % [params.name, position])

func update(delta: float) -> void:
	# 更新所有活动粒子
	var now = Time.get_ticks_msec()
	var to_remove = []
	
	for id in active_particles:
		var particle = active_particles[id]
		var age = now - particle.spawn_time
		
		if age >= particle.lifetime * 1000:
			to_remove.append(id)
		else:
			# 更新粒子位置和状态
			_update_particle(particle, delta)
	
	for id in to_remove:
		active_particles.erase(id)

func _update_particle(particle: Dictionary, delta: float) -> void:
	# 更新单个粒子的物理状态
	var age = (Time.get_ticks_msec() - particle.spawn_time) / 1000.0
	var progress = age / particle.lifetime
	
	# 粒子位置更新
	particle["position"] += particle["params"].speed * delta
	
	# 粒子大小随时间变化
	var size_factor = sin(progress * PI)
	particle["params"]["size"] *= size_factor

func stop_all() -> void:
	# 停止所有粒子特效
	active_particles.clear()
	print("[ParticleSystem] 停止所有粒子特效")

func get_active_count() -> int:
	# 获取当前活动粒子数量
	return active_particles.size()

func get_particle_info(type: String) -> Dictionary:
	# 获取粒子类型信息
	return PARTICLE_TYPES.get(type, {})
