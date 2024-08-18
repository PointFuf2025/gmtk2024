class_name UIManager
extends CanvasLayer

enum  MODE { NONE, PYLON, TURRET, FACTORY }

@export_group("UI Element")
@export var goldLabel : Label
@export var gainPerSecondLabel : Label
@export var musicNameLabel : Label
@export var previousMusicButton : Button
@export var nextMusicButton : Button

@export var turretButton : Button
@export var pylonButtton : Button
@export var factoryButton : Button

@export_group("Audio")
@export var backgroundMusics : Array[AudioStream]
@export var backgroundMusicPlayer : AudioStreamPlayer

var backgroundMusicIndex : int = 0
var mode : MODE = MODE.NONE

signal ModeChanged 

func _ready() -> void:
	previousMusicButton.button_up.connect(_on_previousMusicButton_up)
	nextMusicButton.button_up.connect(_on_nextMusicButton_up)
	backgroundMusicPlayer.finished.connect(_on_backgroundMusicPlayer_finished)
	
	turretButton.toggled.connect(_on_turretButton_toggled)
	pylonButtton.toggled.connect(_on_pylonButton_toggled)
	factoryButton.toggled.connect(_on_factoryButton_toggled)
	
	backgroundMusicIndex = randi_range(0, backgroundMusics.size() - 1)
	playSelectedMusic()

func _on_previousMusicButton_up():
	backgroundMusicIndex += 1
	if backgroundMusicIndex == backgroundMusics.size():
		backgroundMusicIndex = 0
	playSelectedMusic()
	
func _on_nextMusicButton_up():
	backgroundMusicIndex -= 1
	if backgroundMusicIndex == -1:
		backgroundMusicIndex = backgroundMusics.size() - 1
	playSelectedMusic()

func _on_backgroundMusicPlayer_finished():
	backgroundMusicIndex += 1
	if backgroundMusicIndex == backgroundMusics.size():
		backgroundMusicIndex = 0
	playSelectedMusic()

func _on_turretButton_toggled(state : bool):
	if state:
		mode = MODE.TURRET
		ModeChanged.emit();
	
func _on_pylonButton_toggled(state : bool):
	if state:
		mode = MODE.PYLON
		ModeChanged.emit();

func _on_factoryButton_toggled(state : bool):
	if state:
		mode = MODE.FACTORY
		ModeChanged.emit();

func playSelectedMusic():
	var selectedMusic = backgroundMusics[backgroundMusicIndex]
	
	musicNameLabel.text = selectedMusic.resource_path.get_file()
	
	backgroundMusicPlayer.stop()
	backgroundMusicPlayer.stream = selectedMusic
	backgroundMusicPlayer.play()

func updateHUD(gold : int, goldPerSecond : int) -> void:
	goldLabel.text = str(gold)
	gainPerSecondLabel.text = "(+ %s)" % str(goldPerSecond)
