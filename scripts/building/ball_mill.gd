# BallMill - 球磨机
# 对应文档建筑类型列表
extends Building

class_name BallMill

func _init() -> void:
	super._init()
	building_type = BuildingType.BALL_MILL
	display_name = "球磨机"
	size = Vector3i(2, 2, 1)
	power_consumption = 30.0
	recipes = []
	description = "将矿石研磨成粉末"

func _process(delta: float) -> void:
	super._process(delta)
	# 球磨机生产逻辑
