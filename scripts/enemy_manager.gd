class_name EnemyManager
extends Node2D

@export var enemyPackedScene : PackedScene

var enemies : Array[Enemy]

func createEnemy(position : Vector2, factories : Array[Factory], pylons : Array[Pylon], turrets : Array[Turret],  generator : Generator) -> void:
	var enemy = enemyPackedScene.instantiate() as Enemy
	enemy.position = position
	enemy.factories = factories
	enemy.pylons = pylons
	enemy.turrets = turrets
	enemy.generator = generator
	enemy.destroyed.connect(_on_enemy_destroyed)
	
	add_child(enemy)
	
	enemies.append(enemy)

func _on_enemy_destroyed(enemy: Enemy):
	enemies.erase(enemy)
	remove_child(enemy)
