class_name Pylon
extends Clickable

@export var strokeColor: Color
@export var radius: float

@export var audioStreamPlayer : AudioStreamPlayer
@export var spawnSoundEffect : AudioStream

signal pylonCreated

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	isConnected = true
	super._ready()
	pylonCreated.emit()
	isConnected = false;
	audioStreamPlayer.stream = spawnSoundEffect
	audioStreamPlayer.play()
	scale = Vector2.ZERO;

func _process(delta: float) -> void:
	scale = (scale + 0.1 * Vector2.ONE).clamp(Vector2.ZERO, Vector2.ONE)

func _draw() -> void:
	if isHovered:
		draw_circle(Vector2.ZERO, radius, colorTheme.RadiusFillColor, true)
		draw_circle(Vector2.ZERO, radius, colorTheme.RadiusStrokeColor, false)
	
func _on_mouse_entered() -> void:
	super._on_mouse_entered()
	queue_redraw()

func _on_mouse_exited() -> void:
	super._on_mouse_exited()
	queue_redraw()
