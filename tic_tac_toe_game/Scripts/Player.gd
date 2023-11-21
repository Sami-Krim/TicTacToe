extends Node2D

signal Played

@export var first = false


var can_play = true

@onready var grid = get_parent().get_node("Grid")

func _process(_delta: float) -> void:
	if not can_play: return
	if Input.is_action_just_pressed("mouse_click"):
		var pos = grid.get_local_mouse_position()

		if pos.x < 0 or pos.y < 0 or pos.x > 600 or pos.y > 600:return
		var p = Vector2i(pos)/200
		if grid.add_element(int(first), p) == 0:return
		emit_signal("Played")
