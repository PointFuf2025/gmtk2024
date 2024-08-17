class_name Cable_manager
extends Node2D

@export var cablePackedScene : PackedScene

var cableArray: Array[Cable]

func updateFactoryConnectivity(pylons : Array[Pylon], factories : Array[Factory]):
	var cable : Cable
	for pylon in pylons:
		for factory in factories:
			var isInside: bool = pylon.global_position.distance_to(factory.global_position) < pylon.radius
			if isInside && !factory.isConnected: 
				cable = cablePackedScene.instantiate()
				cable.connectCable(pylon.global_position, factory.global_position)
				cableArray.append(cable)
				add_child(cable)
				factory.isConnected = true

func connectClickable(clickable : Clickable, otherClickable : Clickable):
	var cable : Cable
	cable = cablePackedScene.instantiate()
	cable.connectCable(clickable.global_position, otherClickable.global_position)
	cableArray.append(cable)
	add_child(cable)
