class_name Factory_manager
extends Node2D

@export var factoryPackedScene : PackedScene
@export var spawnCurve : Curve

var factories: Array[Factory]

signal factoryCreated
signal gameOver

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func createFactory(position: Vector2) -> void:
	var factory = factoryPackedScene.instantiate() as Factory
	factory.position = position
	add_child(factory)
	factories.append(factory)
	factoryCreated.emit()
	factory.factoryDead.connect(_on_factory_dead)

func _on_factory_dead():
	gameOver.emit()
