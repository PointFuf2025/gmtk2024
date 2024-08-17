class_name Pylon_manager
extends Node2D

@export var pylgonPackedScene : PackedScene
@export var pylonRadius : float

var pylonArray : Array[Pylon]

signal pylonCreated(pylon : Pylon)

func createPylon(position : Vector2) -> void:
	var newPylon = pylgonPackedScene.instantiate() as Pylon;
	newPylon.position = position
	newPylon.radius = pylonRadius
	pylonArray.append(newPylon)		
	add_child(newPylon)
	pylonCreated.emit(newPylon)
	print("pylon created at " + str(position))
	
