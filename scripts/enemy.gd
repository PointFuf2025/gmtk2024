class_name Enemy

extends Entity

@export var area : Area2D
@export var movementSpeed : float
@export var deathSFX : AudioStream
@export var deathTimer : Timer
@export var healthPoints : int

signal destroyed(enemy: Enemy)

var turrets : Array[Turret]
var factories : Array[Factory]
var pylons : Array[Pylon]
var generator : Generator

var targetTimeToUpdate : float
var target : Building
var currentHealthPoints : int

func is_dead() -> bool:
	return currentHealthPoints <= 0 || state == STATE.DEAD

func _ready() -> void:
	super._ready()
	currentHealthPoints = healthPoints
	
	area.area_entered.connect(_on_area_entered)
	update_target()
	deathTimer.timeout.connect(_on_deathTimer_over)
	
	sprite.modulate = sprite.modulate.from_hsv(sprite.modulate.h + randf_range(0, 0.01), sprite.modulate.s, sprite.modulate.v)
	
func _process(delta: float) -> void:
	super._process(delta)
	
	if is_dead():
		sprite.modulate.a = lerp(1, 0, (deathTimer.wait_time - deathTimer.time_left) / deathTimer.wait_time)
		scale = (deathTimer.time_left / deathTimer.wait_time) * Vector2.ONE
		rotation = deathTimer.time_left / deathTimer.wait_time * 90
		position += deathTimer.time_left / deathTimer.wait_time * 250 * delta * Vector2.UP
	else:
		area.position = Vector2.ZERO
		
		targetTimeToUpdate -= delta
		if targetTimeToUpdate < 0:
			target = null
		
		if target == null:
			update_target()
		var direction = (target.position - position).normalized()
	
		sprite.flip_h = direction.x < 0;
		position +=  direction * movementSpeed * delta
	
func update_target():
	var nearestTarget : Building = null
	var nearestTargetDistance : float = 1e10

	for turret in turrets:
		var turretDistance = global_position.distance_to(turret.global_position)
		if turretDistance < nearestTargetDistance:
			nearestTarget = turret
			nearestTargetDistance = turretDistance
			
	for pylon in pylons:
		var pylonDistance = global_position.distance_to(pylon.global_position)
		if pylonDistance < nearestTargetDistance:
			nearestTarget = pylon
			nearestTargetDistance = pylonDistance
			
	if generator != null:		
		var generatorDistance = global_position.distance_to(generator.global_position)
		if generatorDistance < nearestTargetDistance:
			nearestTarget = generator
			nearestTargetDistance = generatorDistance
		
	target = nearestTarget

func takeDamage():
	currentHealthPoints -= 1
	if currentHealthPoints <= 0:
		destroy()

func destroy():
	if is_dead():
		return
	
	audioStreamPlayer.stream = deathSFX
	audioStreamPlayer.play()
	deathTimer.start()
	state = STATE.DEAD
	
func _on_deathTimer_over():
	destroyed.emit(self);

func _on_area_entered(otherArea : Area2D):
	if is_dead():
		return
	
	var building = otherArea.get_parent() as Building
	
	# this has been freed bad code but we can check this
	if pylons.find(target) == 0 || turrets.find(target) == 0:
		target = null
	
	if building == null:
		return
	
	if building == target:
		target.destroy()
		target = null
		update_target()
