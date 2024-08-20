extends Node2D

@export var gameManagerPackedScene : PackedScene
@export var gameManager : GameManager

@export var mainmenu : CanvasLayer
@export var playButton : Button


func _ready() -> void:
	playButton.button_up.connect(_on_playButton_up)
	
func _on_playButton_up():
	startgame()
	
func startgame():
	mainmenu.visible = false;
	
	gameManager = gameManagerPackedScene.instantiate()
	add_child(gameManager)
