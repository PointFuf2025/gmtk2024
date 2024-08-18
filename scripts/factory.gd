class_name Factory

extends Entity

@export var powerGauge: Node2D
@export var startingPower : int
@export var colorTheme : ColorTheme

var power : float

var isConnected : bool = false :
	set(value):
		isConnected = value
		updateColor()
	get:
		return isConnected

signal factoryDead

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	power = startingPower
	isConnected = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	
	powerGauge.get_parent().visible = !isConnected
	if !isConnected:
		decreasePower(delta)

func updateColor() -> void:
	
	var spriteColor = colorTheme.UnconnectedColor;
	
	if isConnected:
		spriteColor = colorTheme.FactoryColor
	
	sprite.modulate = spriteColor

func decreasePower(delta: float):
	if isConnected:
		return
		
	power -= delta * 1
	powerGauge.scale.x = power / startingPower
	
	if power < 0:
		factoryDead.emit()
