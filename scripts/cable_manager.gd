class_name Cable_manager
extends Node2D

@export var cablePackedScene : PackedScene

var cables : Array[Cable]

func updateCables(generator : Generator, pylons : Array[Pylon], factories : Array[Factory], turrets : Array[Turret], max_distance_to_connect : float):
	var cableIndex = 0;
	
	var disconnectedBuildings : Array[Building]
	disconnectedBuildings.append_array(pylons)
	disconnectedBuildings.append_array(factories)
	disconnectedBuildings.append_array(turrets)
	
	for disconnectedBuilding in disconnectedBuildings:
		disconnectedBuilding.setParent(null);
	
	var connectedBuildings : Array[Building]
	connectedBuildings.append(generator)
	
	while connectedBuildings.size() > 0:
		
		var connectedBuilding = connectedBuildings.pop_front()
		
		var newConnectedBuildings : Array[Building]
		
		for disconnectedBuilding in disconnectedBuildings:
			
			var distance = connectedBuilding.global_position.distance_to(disconnectedBuilding.global_position)
			var isInRange: bool = distance < max_distance_to_connect
			if isInRange: 
				var cable = get_or_create_cable(cableIndex)
				disconnectedBuilding.setParent(connectedBuilding)
				cable.connectCable(connectedBuilding.global_position, disconnectedBuilding.global_position)
				cableIndex+=1
				newConnectedBuildings.append(disconnectedBuilding)
				connectedBuildings.append(disconnectedBuilding)
		
		for newConnectedBuilding in newConnectedBuildings:
			disconnectedBuildings.erase(newConnectedBuilding)
	
	while cableIndex < cables.size():
		var cable = cables.pop_back();
		remove_child(cable)
	
func get_or_create_cable(index : int) -> Cable:
	if index == cables.size():
		var cable = cablePackedScene.instantiate()
		cables.append(cable)
		add_child(cable)
		return cable
	else:
		return cables[index]
