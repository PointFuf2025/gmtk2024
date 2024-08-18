class_name Pylon_manager
extends Node2D

@export var pylgonPackedScene : PackedScene

var pylons : Array[Pylon]

signal pylonCreated(pylon : Pylon)
signal pylonDestroyed(pylon : Pylon)

func createPylon(position : Vector2, max_distance_to_connect : float) -> void:
	var newPylon = pylgonPackedScene.instantiate() as Pylon;
	newPylon.position = position
	newPylon.radius = max_distance_to_connect
	newPylon.destroyed.connect(_on_pylon_destoyed)
	pylons.append(newPylon)		
	add_child(newPylon)
	pylonCreated.emit(newPylon)

func _on_pylon_destoyed(building : Building):
	var pylon = building as Pylon
	pylons.erase(pylon)
	#remove_child(pylon)
	pylon.queue_free()
	pylonDestroyed.emit()
