class_name Pylon_manager
extends Node2D

@export var pylgonPackedScene : PackedScene

var pylons : Array[Pylon]

signal pylonCreated(pylon : Pylon)

func createPylon(position : Vector2, max_distance_to_connect : float) -> void:
	var newPylon = pylgonPackedScene.instantiate() as Pylon;
	newPylon.position = position
	newPylon.radius = max_distance_to_connect
	pylons.append(newPylon)		
	add_child(newPylon)
	pylonCreated.emit(newPylon)
	print("pylon created at " + str(position))
	
