class_name Cable
extends Node2D

@export var line: Line2D
 	
func connectCable(pylonPoint: Vector2, otherPoint: Vector2) -> void:
	line.points[0] = pylonPoint
	line.points[1] = otherPoint
	
