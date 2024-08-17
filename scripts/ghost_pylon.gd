class_name Ghost_Pylon
extends Node2D

var clickablePosition
var color
var shouldDraw : bool = false

func _ready() -> void:
	visible = false
	
func update(fromPosition : Vector2, cursorPosition : Vector2, canPlace : bool):
	shouldDraw = true
	visible = true
	if canPlace:
		color = Color.WHITE
		color.a = 0.5
	else:
		color = Color.RED
		color.a = 0.5
	modulate = color
	clickablePosition = fromPosition
	position = cursorPosition
	queue_redraw()	

func showGhost():
	shouldDraw = true
	visible = true

func hideGhost():
	shouldDraw = false
	visible = false

func _draw() -> void:
	if shouldDraw:
		draw_dashed_line(Vector2.ZERO, clickablePosition - position, color, 10, 20)
