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
var target : Building
var currentHealthPoints : int

func is_dead() -> bool:
	return state == STATE.DEAD

func _ready() -> void:
	super._ready()
	currentHealthPoints = healthPoints
	
	area.area_entered.connect(_on_area_entered)
	update_target()
	deathTimer.timeout.connect(_on_deathTimer_over)
	
func _process(delta: float) -> void:
	super._process(delta)
	
	if is_dead():
		sprite.modulate.a = lerp(1, 0, (deathTimer.wait_time - deathTimer.time_left) / deathTimer.wait_time)
		scale = (deathTimer.time_left / deathTimer.wait_time) * Vector2.ONE
	else:
		if target == null:
			update_target()
		var direction = (target.position - position).normalized()
	
		sprite.flip_h = direction.x < 0;
		position +=  direction * movementSpeed * delta
	
func update_target():
	var nearestTarget : Building = null
	var nearestTargetDistance : float = 1e10

	for turret in turrets:
		var turretDistance = position.distance_to(turret.position)
		if turretDistance < nearestTargetDistance:
			nearestTarget = turret
			nearestTargetDistance = turretDistance
	
	# enemy cant target factories	
	# for factory in factories:
		#var factoryDistance = position.distance_to(factory.position)
		#if factoryDistance < nearestTargetDistance:
			#nearestTarget = factory
			#nearestTargetDistance = factoryDistance
			
	for pylon in pylons:
		var pylonDistance = position.distance_to(pylon.position)
		if pylonDistance < nearestTargetDistance:
			nearestTarget = pylon
			nearestTargetDistance = pylonDistance
			
	var generatorDistance = position.distance_to(generator.position)
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
	var building = otherArea.get_parent() as Building
	
	if building == null:
		return
	
	# this has been freed bad code but we can check this
	if pylons.find(target) == 0 || turrets.find(target) == 0:
		target = null
	
	if building == target:
		target.destroy()
		target = null
		update_target()
