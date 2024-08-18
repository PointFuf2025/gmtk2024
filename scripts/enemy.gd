class_name Enemy

extends Entity

@export var area : Area2D
@export var movementSpeed : float

signal destroyed(enemy: Enemy)

var turrets : Array[Turret]
var factories : Array[Factory]
var pylons : Array[Pylon]
var generator : Generator

var target : Building

func _ready() -> void:
	super._ready()
	area.area_entered.connect(_on_area_entered)
	update_target()
	
func _process(delta: float) -> void:
	super._process(delta)
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
	
	for factory in factories:
		var factoryDistance = position.distance_to(factory.position)
		if factoryDistance < nearestTargetDistance:
			nearestTarget = factory
			nearestTargetDistance = factoryDistance
			
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

func destroy():
	destroyed.emit(self);
	
func _on_area_entered(otherArea : Area2D):
	var building = otherArea.get_parent() as Building
	if building == target:
		target.destroy()
		target = null
		update_target()
