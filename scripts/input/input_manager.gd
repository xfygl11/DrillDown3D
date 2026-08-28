# 输入管理器 - 处理所有用户输入
extends Node

class_name InputManager

signal tile_clicked(x: int, y: int, z: int)
signal building_placed(type: String, x: int, y: int, z: int)
signal game_paused(paused: bool)

var touch_start_pos: Vector2 = Vector2.ZERO
var is_dragging: bool = false
const DRAG_THRESHOLD := 10.0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE or event.keycode == KEY_P:
			_toggle_pause()
		elif event.keycode == KEY_S and Input.is_key_pressed(KEY_CTRL):
			_save_game()
		elif event.keycode == KEY_O and Input.is_key_pressed(KEY_CTRL):
			_load_game()
	
	elif event is InputEventScreenTouch:
		if event.pressed:
			touch_start_pos = event.position
			is_dragging = false
		else:
			var drag_dist = (event.position - touch_start_pos).length()
			if drag_dist < DRAG_THRESHOLD:
				_handle_tap(event.position)
	
	elif event is InputEventScreenDrag:
		if not is_dragging:
			var drag_dist = (event.position - touch_start_pos).length()
			if drag_dist >= DRAG_THRESHOLD:
				is_dragging = true

func _handle_tap(position: Vector2) -> void:
	# 模拟点击瓦片
	var tile_x = int(position.x / 40)
	var tile_y = int(position.y / 40)
	tile_clicked.emit(tile_x, tile_y, 0)

func _toggle_pause() -> void:
	var paused = true
	game_paused.emit(paused)

func _save_game() -> void:
	print("[Input] 保存游戏...")
	game_paused.emit(true)

func _load_game() -> void:
	print("[Input] 加载游戏...")
	game_paused.emit(false)
