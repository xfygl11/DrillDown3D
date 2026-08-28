# 触摸控制器 - 处理触摸屏输入
extends Node

class_name TouchController

signal tile_selected(x: int, y: int)
signal building_placed(type: String, x: int, y: int, z: int)
signal camera_moved(delta: Vector2)

var is_dragging: bool = false
var drag_start: Vector2 = Vector2.ZERO
const DRAG_THRESHOLD: float = 10.0
var audio_manager: AudioManager = null

func _ready() -> void:
	audio_manager = get_node("/root/AudioManager")

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		_on_touch(event)
	elif event is InputEventScreenDrag:
		_on_drag(event)

func _on_touch(event: InputEventScreenTouch) -> void:
	if event.pressed:
		drag_start = event.position
		is_dragging = false
	else:
		var distance = (event.position - drag_start).length()
		if distance < DRAG_THRESHOLD:
			_handle_tap(event.position)

func _on_drag(event: InputEventScreenDrag) -> void:
	if not is_dragging:
		var distance = (event.position - drag_start).length()
		if distance >= DRAG_THRESHOLD:
			is_dragging = true
			camera_moved.emit(Vector2.ZERO)
	
	if is_dragging:
		var delta = event.relative * 0.5
		camera_moved.emit(delta)

func _handle_tap(position: Vector2) -> void:
	var tile_x = int(position.x / 40)
	var tile_y = int(position.y / 40)
	tile_selected.emit(tile_x, tile_y)
	if audio_manager:
		audio_manager.play_click()
