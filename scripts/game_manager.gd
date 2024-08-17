class_name GameManager
extends Node2D

@export var generatorPackedScene : PackedScene

@export_group("manager")
@export var factory_manager : Factory_manager
@export var cable_manager : Cable_manager
@export var pylon_manager : Pylon_manager
@export var ui_manager : UIManager

@export_group("Spawn") 
@export var spawnRange_startingValue : float
@export var spawnRange_increasePerSecond : float
@export var factorySpawnIntervallOverTime : Curve

var spawnRange : float
var timeToIncome : float
var timeToSpawn : float # For tracking the quantity to spawn over time
var timeSinceStart : float
var gold : float

var generator : Generator
var hoveredClickable : Clickable
var selectedClickable : Clickable

# for now just let game manager start with ready
func _ready() -> void:
	# create and add the generator
	generator = generatorPackedScene.instantiate() as Generator
	generator.position = DisplayServer.screen_get_size() / 2
	connectClickable(generator)
	add_child(generator)
	factory_manager.factoryCreated.connect(_on_factory_created)
	factory_manager.gameOver.connect(_on_game_over)
	pylon_manager.pylonCreated.connect(_on_pylon_created)
	spawnRange = spawnRange_startingValue
	timeSinceStart = 0
	
func _process(delta: float) -> void:
	process_factory_spawn(delta)
	process_factory_income(delta)
	timeSinceStart += delta

func process_factory_spawn(delta : float) -> void:
	spawnRange += spawnRange_increasePerSecond * delta	
	if timeToSpawn < 0:
		var randomAngle = randf_range(0, 2 * PI)
		var randomDistance = randf_range(0.8, 1) * spawnRange
		var randomPosition = generator.position + (Vector2.RIGHT * randomDistance).rotated(randomAngle)
		factory_manager.createFactory(randomPosition)
		
		var normalizedTimeSinceStart = clamp(timeSinceStart / (10 * 60), 0, 1)
		timeToSpawn = factorySpawnIntervallOverTime.sample(normalizedTimeSinceStart)
	timeToSpawn -= delta
	
func process_factory_income(delta : float) -> void:
	if timeToIncome <0:
		var goldIncomePerSecond = factory_manager.get_gold_income_from_factories();
		gold += goldIncomePerSecond
		timeToIncome = 1;
		ui_manager.updateHUD(gold, goldIncomePerSecond)
		
	timeToIncome -= delta
	
func connectClickable(clickable : Clickable):
	clickable.hovered.connect(_on_clickable_hovered)
	
func _on_clickable_hovered(newHoveredClickable : Clickable, state : bool) -> void:		
	if state:
		if hoveredClickable == null:
			hoveredClickable = newHoveredClickable
	else:
		if hoveredClickable == newHoveredClickable:
			hoveredClickable = null
			
func _on_factory_created():
	cable_manager.updateFactoryConnectivity(pylon_manager.pylons, factory_manager.factories)

func _on_pylon_created(pylon : Pylon):
		connectClickable(pylon)
		#TODO optim func to update only a given pylon connectivity
		cable_manager.updateFactoryConnectivity(pylon_manager.pylons, factory_manager.factories)
		cable_manager.connectClickable(selectedClickable, pylon)
		
func _on_game_over():
	get_tree().reload_current_scene()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		var mousePosition = get_global_mouse_position();
		
		if hoveredClickable != null:
			selectClickable(hoveredClickable)
		elif selectedClickable != null:
			pylon_manager.createPylon(mousePosition)
			selectClickable(null)
			
	elif event.is_action_pressed("cancel"):
		selectClickable(null)

func selectClickable(newSelectedClickable: Clickable) -> void:
		if newSelectedClickable == selectedClickable:
			return
	
		if newSelectedClickable == null:
			if selectedClickable != null:
				selectedClickable.isSelected = false
				selectedClickable = null	
		else:
			if selectedClickable != null:
				selectedClickable.isSelected = false
				selectedClickable = null
			selectedClickable = newSelectedClickable
			selectedClickable.isSelected = true
