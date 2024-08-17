class_name Cable
extends Node2D

@export var line: Line2D
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func connectCable(pylonPoint: Vector2, otherPoint: Vector2) -> void:
	visible = true
	line.points[0] = pylonPoint
	line.points[1] = otherPoint
	
