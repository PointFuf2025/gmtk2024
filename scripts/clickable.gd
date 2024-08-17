class_name Clickable

extends Node2D

signal hovered(clickable : Clickable, isHovered : bool)

@export var area2d : Area2D
@export var colorTheme : ColorTheme

@export var sprite : Sprite2D

var isSelected : bool :
	set (value):
		isSelected = value
		updateColor()
		
var isHovered : bool :
	set (value):
		isHovered = value
		updateColor()

var isConnected : bool :
	set (value):
		isConnected = value
		updateColor()

func updateColor() -> void:
	
	var spriteColor = colorTheme.UnconnectedColor;
	
	if isSelected:
		spriteColor = colorTheme.SelectedColor
	elif isHovered:
		spriteColor = colorTheme.HoveredColor
	elif is_connected:
		spriteColor = colorTheme.ConnectedColor
	
	sprite.modulate = spriteColor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area2d.mouse_entered.connect(_on_mouse_entered)
	area2d.mouse_exited.connect(_on_mouse_exited)

func  _on_mouse_entered() -> void:
	print("clickable: start hovered")
	isHovered = true
	hovered.emit(self, true)
	
func  _on_mouse_exited() -> void:
	print("clickable: stop hovered")
	isHovered = false
	hovered.emit(self, false)
