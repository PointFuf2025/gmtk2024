class_name Clickable

extends Node2D

signal hovered(clickable : Clickable, isHovered : bool)

@export var area2d : Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area2d.mouse_entered.connect(_on_mouse_entered)
	area2d.mouse_exited.connect(_on_mouse_exited)
	
func  _on_mouse_entered() -> void:
	print("clickable: start hovered")
	hovered.emit(self, true)	

func  _on_mouse_exited() -> void:
	print("clickable: stop hovered")
	hovered.emit(self, false)
