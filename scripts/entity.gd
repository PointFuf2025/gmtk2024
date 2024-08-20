class_name Entity
extends Node2D

enum STATE { FADE_IN, IDLE, DEAD }

@export var sprite : Sprite2D

var state : STATE
var elapsedTime : float
var randomOffsetForAnimation : float

@export var audioStreamPlayer : AudioStreamPlayer2D
@export var spawnSoundEffect : AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state = STATE.FADE_IN
	scale = Vector2.ZERO;
	randomOffsetForAnimation = randf_range(0, 10)
	if spawnSoundEffect != null:
		audioStreamPlayer.pitch_scale = randf_range(0.8, 1.2)
		audioStreamPlayer.stream = spawnSoundEffect
		audioStreamPlayer.play()

func _process(delta: float) -> void:
	elapsedTime += delta
	
	match state:
		STATE.FADE_IN:
			scale = (scale + 0.05 * Vector2.ONE).clamp(Vector2.ZERO, Vector2.ONE)
			if scale == Vector2.ONE:
				state = STATE.IDLE
		STATE.IDLE:
			scale = (1 + 0.05 * cos(4 * elapsedTime + randomOffsetForAnimation)) * Vector2.ONE
			rotation = deg_to_rad(5) * cos(2 * elapsedTime + randomOffsetForAnimation) 
