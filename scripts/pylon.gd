class_name Pylon
extends Clickable

@export var strokeColor: Color

signal pylonCreated

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	isConnected = true
	super._ready()
	pylonCreated.emit()
	isConnected = false;

func _on_mouse_entered() -> void:
	super._on_mouse_entered()

func _on_mouse_exited() -> void:
	super._on_mouse_exited()
