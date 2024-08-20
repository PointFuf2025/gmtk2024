class_name Ghost
extends Node2D

@export var sprite : Sprite2D
@export var pylonSprite : Texture2D
@export var turretSprite : Texture2D
@export var factorySprite : Texture2D
@export var colorTheme : ColorTheme

var clickablePosition
var color
var shouldDraw : bool = false
var timeElapsed = 0
var radius : float

func _ready() -> void:
	visible = false
	timeElapsed = 0 
	
func _process(delta: float) -> void:
	timeElapsed += delta
	
func update(fromPosition : Vector2, cursorPosition : Vector2, mode : UIManager.MODE, canPlace : bool, radius : float):
	shouldDraw = true
	visible = true
	
	self.radius = radius
	
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
		draw_circle(Vector2.ZERO, radius, colorTheme.RadiusFillColor, true)
		draw_circle(Vector2.ZERO, radius, colorTheme.RadiusStrokeColor, false)
