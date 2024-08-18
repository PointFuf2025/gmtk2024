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
	
	if reloadTimeLeft < 0:
		var nearestEnemy : Enemy = null
		var nearestEnemyDistance : float = 1e10
		
		for enemy in enemies:
			var enemyDistance = position.distance_to(enemy.position)
			
			if enemyDistance > attackRadius:
				continue
			
			if enemyDistance < nearestEnemyDistance:
				nearestEnemy = enemy
				nearestEnemyDistance = enemyDistance
		
		if nearestEnemy != null:
			var projectile = projectilePackedScene.instantiate() as Projectile
			projectile.direction = nearestEnemy.position - position
			add_child(projectile)
			#nearestEnemy.destroy()
			reloadTimeLeft = reloadDuration
		
	reloadTimeLeft -= delta
		
func updateColor() -> void:
	
	var spriteColor = colorTheme.UnconnectedColor;
	
	if isConnected:
		spriteColor = colorTheme.TurretColor
	
	sprite.modulate = spriteColor
