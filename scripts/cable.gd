class_name Cable
extends Node2D

@export var colorTheme : ColorTheme

var timeElapsed = 0	
var position1 : Vector2
var position2 : Vector2
	
func connectCable(pylonPoint: Vector2, otherPoint: Vector2) -> void:
	position1 = pylonPoint
	position2 = otherPoint
	
func _process(delta: float) -> void:
	timeElapsed += delta	
	queue_redraw()
	
func _draw() -> void:
		var dashLength = 5 + 5 * (floori(timeElapsed * 5) % 3 + 1)
		draw_dashed_line(position1 - position, position2 - position, colorTheme.ConnectedColor, 10, dashLength)
