class_name Factory_manager
extends Node2D

@export var factoryPackedScene : PackedScene
@export var goldIncomeByFactory : int

var factories: Array[Factory]

signal factoryCreated
signal gameOver

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_connected_factories_count():
	var count : int = 0;
	for factory in factories:
		if factory.isConnected:
			count += 1
	return count
	
func get_gold_income_from_factories() -> int:
	return goldIncomeByFactory * get_connected_factories_count()

func createFactory(position: Vector2) -> void:
	var factory = factoryPackedScene.instantiate() as Factory
	factory.position = position
	add_child(factory)
	factories.append(factory)
	factoryCreated.emit()
	factory.factoryDead.connect(_on_factory_dead)

func _on_factory_dead():
	gameOver.emit()
