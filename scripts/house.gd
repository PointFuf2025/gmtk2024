class_name Factory
extends Node2D

@export var powerGauge: Node2D
@export var startingPower : int

var power : float
var isConnected : bool

signal factoryDead

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	power = startingPower
	isConnected = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#TODO global var powerLossPerSecond
	powerGauge.get_parent().visible = !isConnected
	if !isConnected:
		decreasePower(delta)

func decreasePower(delta: float):
	if isConnected:
		return
	power -= delta * 1
	powerGauge.scale.x = power / startingPower
	if power < 0:
		factoryDead.emit()
