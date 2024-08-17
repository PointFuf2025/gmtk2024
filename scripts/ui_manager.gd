class_name UIManager
extends CanvasLayer

@export_group("UI Element")
@export var goldLabel : Label
@export var gainPerSecondLabel : Label
@export var musicNameLabel : Label
@export var previousMusicButton : Button
@export var nextMusicButton : Button


@export_group("Audio")
@export var backgroundMusics : Array[AudioStream]
@export var backgroundMusicPlayer : AudioStreamPlayer
var backgroundMusicIndex : int = 0

func _ready() -> void:
	previousMusicButton.button_up.connect(_on_previousMusicButton_up)
	nextMusicButton.button_up.connect(_on_nextMusicButton_up)
	backgroundMusicPlayer.finished.connect(_on_backgroundMusicPlayer_finished)
	
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

func playSelectedMusic():
	var selectedMusic = backgroundMusics[backgroundMusicIndex]
	
	musicNameLabel.text = selectedMusic.resource_path.get_file()
	
	backgroundMusicPlayer.stop()
	backgroundMusicPlayer.stream = selectedMusic
	backgroundMusicPlayer.play()

func updateHUD(gold : int, goldPerSecond : int) -> void:
	goldLabel.text = str(gold)
	gainPerSecondLabel.text = "(+ %s)" % str(goldPerSecond)
