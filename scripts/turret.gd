class_name Turret

extends Building

@export var attackRadius : float
@export var reloadDuration : float
@export var colorTheme : ColorTheme

@export var projectilePackedScene : PackedScene

@export var scaleTimer : Timer

var isHovered = false
var reloadTimeLeft = 0;

var enemies : Array[Enemy]


func setParent(newParent : Building):
	parent = newParent
	updateColor()

func  _ready() -> void:
	super._ready()
	
	area2d.mouse_entered.connect(_on_mouse_entered)
	area2d.mouse_exited.connect(_on_mouse_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	
	area2d.position = Vector2.ZERO
	
	scale += 0.5 * Vector2.ONE * scaleTimer.time_left / scaleTimer.wait_time
	
	if isConnected():
		_process_try_to_fire(delta)
	
	queue_redraw()
		
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
			
			var enemyDirection = (nearestEnemy.position - position).normalized()
			
			scaleTimer.start()
			
			sprite.flip_h = enemyDirection.x < 0
			
			var projectile = projectilePackedScene.instantiate() as Projectile
			projectile.global_position = self.global_position
			projectile.direction = enemyDirection
			get_parent().add_child(projectile)
			reloadTimeLeft = reloadDuration
		
	reloadTimeLeft -= delta

func _draw() -> void:
		if isHovered:
			draw_circle(Vector2.ZERO, attackRadius, colorTheme.RadiusFillColor, true)
			draw_circle(Vector2.ZERO, attackRadius, colorTheme.RadiusStrokeColor, false)
		
func  _on_mouse_entered() -> void:
	isHovered = true
	
func  _on_mouse_exited() -> void:
	isHovered = false
		
func updateColor() -> void:
	
	var spriteColor = colorTheme.UnconnectedColor;
	
	if isConnected():
		spriteColor = colorTheme.TurretColor
	
	sprite.modulate = spriteColor
