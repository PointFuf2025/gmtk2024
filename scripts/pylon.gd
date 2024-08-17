class_name Pylon
extends Clickable

@export var fillColor: Color
@export var strokeColor: Color
@export var radius: float
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, fillColor, true)
	draw_circle(Vector2.ZERO, radius, strokeColor, false)
