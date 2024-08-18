class_name Factory

extends Entity

@export var powerGauge: Node2D
@export var colorTheme : ColorTheme

var isConnected : bool = false :
	set(value):
		isConnected = value
		updateColor()
	get:
		return isConnected

func updateColor() -> void:
	
	var spriteColor = colorTheme.UnconnectedColor;
	
	if isConnected:
		spriteColor = colorTheme.FactoryColor
	
	sprite.modulate = spriteColor
