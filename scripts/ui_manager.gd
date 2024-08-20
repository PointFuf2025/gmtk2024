class_name UIManager
extends CanvasLayer

enum  MODE { NONE, PYLON, TURRET, FACTORY }

@export_group("UI Element")
@export var goldLabel : Label
@export var musicNameLabel : Label
@export var previousMusicButton : Button
@export var nextMusicButton : Button

@export var towerRangeUpgrade : Button
@export var towerReloadTimeUpgrade : Button
@export var pylonRangeUpgrade : Button
@export var factorySpawnUpgrade : Button
@export var factoryIncomeUpgrade : Button

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
	updateMode()
	
func _on_pylonButton_toggled(state : bool):
	updateMode()

func _on_factoryButton_toggled(state : bool):
	updateMode()

func updateMode():
	var previousMode = mode
	
	if turretButton.button_pressed:
		mode = MODE.TURRET
	elif pylonButtton.button_pressed:
		mode = MODE.PYLON
	elif factoryButton.button_pressed:
		mode = MODE.FACTORY
	else:
		mode = MODE.NONE 
		
	if mode != previousMode:
		ModeChanged.emit()

func setTurretPrices(towerPrice: int, pylonPrice: int, factoryPrice: int):
	turretButton.text = "Tower \n (" + str(towerPrice) + ")"
	pylonButtton.text = "Pylon \n (" + str(pylonPrice) + ")"
	factoryButton.text = "Factory \n (" + str(factoryPrice) + ")"

func setUpgradePrices(towerRange: int, towerReload: int, pylonRange: int, factoryIncome: int, factorySpawn: int, gold: int):
	towerRangeUpgrade.text = "Tower Range (" + str(towerRange) + ")"
	towerReloadTimeUpgrade.text = "Tower Reload Time(" + str(towerReload) + ")"
	pylonRangeUpgrade.text = "Pylon Range (" + str(pylonRange) + ")"
	factoryIncomeUpgrade.text = "Factory Spawn Rate \n (" + str(factoryIncome) + ")"
	factorySpawnUpgrade.text = "Factory Income \n (" + str(factorySpawn) + ")"
	
	towerRangeUpgrade.disabled = towerRange > gold
	towerReloadTimeUpgrade.disabled = towerReload > gold
	pylonRangeUpgrade.disabled = pylonRange > gold
	factoryIncomeUpgrade.disabled = factoryIncome > gold
	factorySpawnUpgrade.disabled = factorySpawn > gold
	
func playSelectedMusic():
	var selectedMusic = backgroundMusics[backgroundMusicIndex]
	
	musicNameLabel.text = selectedMusic.resource_path.get_file()
	
	backgroundMusicPlayer.stop()
	backgroundMusicPlayer.stream = selectedMusic
	backgroundMusicPlayer.play()

func updateHUD(gold : int) -> void:
	goldLabel.text = str(gold)
