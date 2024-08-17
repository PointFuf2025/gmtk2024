class_name Factory
extends Node2D

@export var powerGauge: Node2D
@export var startingPower : int

var power : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	power = startingPower

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#TODO global var powerLossPerSecond
	if (power > 0):
		power -= delta * 1
		print(power)
		powerGauge.scale.x = power / startingPower
		print(powerGauge.scale.x)
	else:
		print("you loose")
