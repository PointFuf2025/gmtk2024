class_name Ghost_Pylon
extends Node2D

@export var sprite : Sprite2D
@export var pylonSprite : Texture2D
@export var turretSprite : Texture2D
@export var factorySprite : Texture2D

var clickablePosition
var color
var shouldDraw : bool = false
var timeElapsed = 0

func _ready() -> void:
	visible = false
	timeElapsed = 0 
	
func _process(delta: float) -> void:
	timeElapsed += delta
	
func update(fromPosition : Vector2, cursorPosition : Vector2, mode : UIManager.MODE, canPlace : bool):
	shouldDraw = true
	visible = true
	
	sprite.texture = get_texture_for_mode(mode)
	
	color = Color.WHITE if canPlace else Color.RED
	color.a = 0.5
		
	modulate = color
	clickablePosition = fromPosition
	position = cursorPosition
	queue_redraw()	

func get_texture_for_mode(mode : UIManager.MODE) -> Texture2D:
	match mode:
		UIManager.MODE.PYLON:
			return pylonSprite
		UIManager.MODE.FACTORY:
			return factorySprite
		UIManager.MODE.TURRET:
			return turretSprite
	return null

func showGhost():
	shouldDraw = true
	visible = true

func hideGhost():
	shouldDraw = false
	visible = false

func _draw() -> void:
	if shouldDraw:
		var dashLength = 5 + 5 * (floori(timeElapsed * 5) % 3 + 1)
		draw_dashed_line(Vector2.ZERO, clickablePosition - position, color, 10, dashLength)
