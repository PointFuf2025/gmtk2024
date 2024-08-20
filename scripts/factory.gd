class_name Factory

extends Building

signal incomeGained(income : int)

var timeLeftToIncome : float

@export var powerGauge: Node2D
@export var powerGaugeBackground : Node2D

@export var label : Label
@export var labelTimer : Timer

@export var incomeIntervall : int
@export var income : int
@export var colorTheme : ColorTheme

@export var incomeAudioStream : AudioStream

func _ready() -> void:
	super._ready()	
	timeLeftToIncome = incomeIntervall

func _process(delta: float) -> void:
	super._process(delta)	
	
	var isConnected = isConnected()
	
	powerGaugeBackground.visible = isConnected;
	
	scale += 0.5 * Vector2.ONE * labelTimer.time_left / labelTimer.wait_time
	label.position.y = -150 - 20 * labelTimer.time_left / labelTimer.wait_time
	label.modulate.a = labelTimer.time_left / labelTimer.wait_time
	
	if isConnected:
		if timeLeftToIncome < 0:
			audioStreamPlayer.stream = incomeAudioStream
			audioStreamPlayer.play()
			incomeGained.emit(income);			
			timeLeftToIncome = incomeIntervall
			
			label.text = "+" + str(income)
			labelTimer.start()
			
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
