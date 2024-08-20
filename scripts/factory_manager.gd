class_name Factory_manager
extends Node2D

@export var factoryPackedScene : PackedScene
@export var goldIncomeByFactory : int

var factories: Array[Factory]

signal factoryCreated
signal factoryDestroyed
signal incomeGained(income : int)
	
func is_position_available_for_building(position : Vector2, minimalDistance : float):
	for factory in factories:
		if factory.global_position.distance_to(position) < minimalDistance:
			return false
	return true
	
func get_connected_factories_count():
	var count : int = 0;
	for factory in factories:
		if factory.isConnected():
			count += 1
	return count + 1
	
func get_gold_income_from_factories() -> int:
	return goldIncomeByFactory * get_connected_factories_count()

func createFactory(position: Vector2) -> void:
	var factory = factoryPackedScene.instantiate() as Factory
	factory.position = position
	factory.destroyed.connect(_on_factory_destoyed)
	factory.incomeGained.connect(_on_factory_incomeGained)
	add_child(factory)
	factories.append(factory)
	factoryCreated.emit()

func updateFactoryStats(income: float):
	pass

func _on_factory_destoyed(building : Building):
	var factory = building as Factory
	factories.erase(factory)
	remove_child(factory)
	factoryDestroyed.emit()
	
func _on_factory_incomeGained(income : int):
	incomeGained.emit(income)
