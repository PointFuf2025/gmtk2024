class_name ClickableBuilding
extends Building

signal hovered(clickable : ClickableBuilding, isHovered : bool)

@export var colorTheme : ColorTheme
@export var radius: float
		
var isHovered : bool :
	set (value):
		isHovered = value
		updateColor()
		queue_redraw()

func setParent(newParent : Building):
		parent = newParent
		updateColor()
		queue_redraw()

func updateColor() -> void:
	
	var spriteColor = colorTheme.UnconnectedColor;
	
	if isConnected():
		spriteColor = colorTheme.ConnectedColor
	
	sprite.modulate = spriteColor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	area2d.mouse_entered.connect(_on_mouse_entered)
	area2d.mouse_exited.connect(_on_mouse_exited)
	updateColor()

func  _on_mouse_entered() -> void:
	print("clickable: start hovered")
	isHovered = true
	hovered.emit(self, true)
	
func  _on_mouse_exited() -> void:
	print("clickable: stop hovered")
	isHovered = false
	hovered.emit(self, false)	
