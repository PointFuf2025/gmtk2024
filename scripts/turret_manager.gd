class_name TurretManager

extends Node2D

signal turretCreated
signal turretDestroyed

@export var turretPackedScene : PackedScene

var turrets : Array[Turret]

func is_position_available_for_building(position : Vector2, minimalDistance : float):
	for turret in turrets:
		if turret.global_position.distance_to(position) < minimalDistance:
			return false
	return true

func createTurret(position : Vector2, enemies : Array[Enemy]):
	var turret = turretPackedScene.instantiate() as Turret
	turret.position = position
	turret.enemies = enemies
	turret.destroyed.connect(_on_turret_destroyed)
	turrets.append(turret)
	add_child(turret)
	
	turretCreated.emit()

func _on_turret_destroyed(building : Building):
	var turret = building as Turret
	turrets.erase(turret)
	#remove_child(turret)
	turret.queue_free()
	turretDestroyed.emit()

func updateTurretStats(reloadTime : float, range : float):
	for turret in turrets:
		turret.reloadDuration -= reloadTime
		turret.attackRadius += range
