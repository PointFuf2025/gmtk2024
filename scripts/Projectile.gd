class_name Projectile
extends Area2D

@export var colorTheme : ColorTheme
@export var collisionShape : CollisionShape2D
@export var speed : int
@export var lifetime : float

var lifetimeLeft : float
var direction: Vector2

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	lifetimeLeft = lifetime
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	#update pos
	position += direction * delta * speed
	
	#update lifetime and kill object IFN
	lifetimeLeft -= delta
	if lifetimeLeft <= 0:
		queue_free()
		
func _draw() -> void:
	var circleShape = collisionShape.shape as CircleShape2D
	draw_circle(Vector2.ZERO, circleShape.radius, colorTheme.TurretColor)

func _on_area_entered(otherArea : Area2D):
	var enemy = otherArea.get_parent() as Enemy
	if enemy != null:
		enemy.takeDamage()
		queue_free()
