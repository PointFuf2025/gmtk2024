class_name Factory

extends Building

@export var powerGauge: Node2D
@export var colorTheme : ColorTheme

func setParent(newParent : Building):
	parent = newParent 
	updateColor()

func updateColor() -> void:
	
	var spriteColor = colorTheme.UnconnectedColor;
	
	if isConnected():
		spriteColor = colorTheme.FactoryColor
	
	sprite.modulate = spriteColor
