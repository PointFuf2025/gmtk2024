class_name Pylon
extends Clickable

@export var fillColor: Color
@export var strokeColor: Color
@export var radius: float

var isConnected: bool

signal pylonCreated

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pylonCreated.emit()
	isConnected = false;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, fillColor, true)
	draw_circle(Vector2.ZERO, radius, strokeColor, false)
