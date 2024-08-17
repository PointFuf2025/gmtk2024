class_name Pylon
extends Clickable

@export var fillColor: Color
@export var strokeColor: Color
@export var radius: float

var isConnected: bool

signal pylonCreated

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	pylonCreated.emit()
	isConnected = false;

func _draw() -> void:
	if isHovered:
		draw_circle(Vector2.ZERO, radius, fillColor, true)
		draw_circle(Vector2.ZERO, radius, strokeColor, false)
	
func _on_mouse_entered() -> void:
	super._on_mouse_entered()
	queue_redraw()

func _on_mouse_exited() -> void:
	super._on_mouse_exited()
	queue_redraw()
