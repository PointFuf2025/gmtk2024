class_name Turret

extends Building

@export var attackRadius : float
@export var reloadDuration : float
@export var colorTheme : ColorTheme

@export var projectilePackedScene : PackedScene

var reloadTimeLeft = 0;

var enemies : Array[Enemy]


func setParent(newParent : Building):
	parent = newParent
	updateColor()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	
	if isConnected():
		_process_try_to_fire(delta)
		
func _process_try_to_fire(delta: float) -> void:
	if reloadTimeLeft < 0:
		var nearestEnemy : Enemy = null
		var nearestEnemyDistance : float = 1e10
		
		for enemy in enemies:
			
			if enemy.is_dead():
				continue
			
			var enemyDistance = position.distance_to(enemy.position)
			
			if enemyDistance > attackRadius:
				continue
			
			if enemyDistance < nearestEnemyDistance:
				nearestEnemy = enemy
				nearestEnemyDistance = enemyDistance
		
		if nearestEnemy != null:
			var projectile = projectilePackedScene.instantiate() as Projectile
			projectile.global_position = self.global_position
			projectile.direction = (nearestEnemy.position - position).normalized()
			get_parent().add_child(projectile)
			reloadTimeLeft = reloadDuration
		
	reloadTimeLeft -= delta
		
func updateColor() -> void:
	
	var spriteColor = colorTheme.UnconnectedColor;
	
	if isConnected():
		spriteColor = colorTheme.TurretColor
	
	sprite.modulate = spriteColor
