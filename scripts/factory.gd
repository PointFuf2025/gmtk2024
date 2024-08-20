class_name Factory

extends Building

signal incomeGained(income : int)

var timeLeftToIncome : float

@export var powerGauge: Node2D
@export var powerGaugeBackground : Node2D

@export var incomeIntervall : int
@export var income : int
@export var colorTheme : ColorTheme

func _ready() -> void:
	super._ready()	
	timeLeftToIncome = incomeIntervall

func _process(delta: float) -> void:
	super._process(delta)	
	
	var isConnected = isConnected()
	
	powerGaugeBackground.visible = isConnected;
	
	if isConnected:
		if timeLeftToIncome < 0:
			incomeGained.emit(income);
			timeLeftToIncome = incomeIntervall
		else:
			timeLeftToIncome -= delta
	
		powerGauge.scale.x = (incomeIntervall - timeLeftToIncome) / incomeIntervall

func setParent(newParent : Building):
	parent = newParent 
	updateColor()

func updateColor() -> void:
	
	var spriteColor = colorTheme.UnconnectedColor;
	
	if isConnected():
		spriteColor = colorTheme.FactoryColor
	
	sprite.modulate = spriteColor
