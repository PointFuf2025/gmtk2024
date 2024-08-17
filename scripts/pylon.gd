extends Node2D

@export var powerRadiusColor: Color
@export var radius: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_circle(position, radius, powerRadiusColor, true)
