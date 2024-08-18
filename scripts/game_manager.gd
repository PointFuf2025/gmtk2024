class_name GameManager
extends Node2D

@export var generatorPackedScene : PackedScene

@export_group("manager")
@export var factory_manager : Factory_manager
@export var cable_manager : Cable_manager
@export var pylon_manager : Pylon_manager
@export var ui_manager : UIManager
@export var camera : Camera

@export_group("Spawn") 
@export var spawnRange_startingValue : float
@export var spawnRange_increasePerSecond : float
@export var factorySpawnIntervallOverTime : Curve

@export_group("Entity") 
@export var max_distance_to_connect : float
@export var pylon_price : int
@export var turret_price : int
@export var factory_price : int

@export_group("Ghost")
@export var ghost_pylon : Ghost_Pylon
 
var spawnRange : float
var timeToIncome : float
var timeToSpawn : float # For tracking the quantity to spawn over time
var timeSinceStart : float
var gold : float

var generator : Generator
var hoveredClickable : Clickable
var selectedClickable : Clickable:
	set(value):
		selectedClickable = value
			
# for now just let game manager start with ready
func _ready() -> void:
	# create and add the generator
	gold = 50
	generator = generatorPackedScene.instantiate() as Generator
	generator.position = DisplayServer.screen_get_size() / 2
	generator.radius = max_distance_to_connect
	connectClickable(generator)
	add_child(generator)
	factory_manager.factoryCreated.connect(_on_factory_created)
	factory_manager.gameOver.connect(_on_game_over)
	pylon_manager.pylonCreated.connect(_on_pylon_created)
	ui_manager.ModeChanged.connect(_on_mode_changed)
	spawnRange = spawnRange_startingValue
	timeSinceStart = 0
	camera.position = generator.position
	
func _process(delta: float) -> void:
	process_enemy_spawn(delta)
	process_factory_income(delta)
	
	if selectedClickable != null && ui_manager.mode != UIManager.MODE.NONE:
		var canPlace = can_place_in_current_mode()
		ghost_pylon.update(selectedClickable.position, get_global_mouse_position(), ui_manager.mode, canPlace)
	else:
		ghost_pylon.hideGhost()
		
	timeSinceStart += delta

func process_enemy_spawn(delta : float) -> void:
	spawnRange += spawnRange_increasePerSecond * delta	
	if timeToSpawn < 0:
		var randomAngle = randf_range(0, 2 * PI)
		var randomDistance = randf_range(0.8, 1) * spawnRange
		var randomPosition = generator.position + (Vector2.RIGHT * randomDistance).rotated(randomAngle)
		
		#spawn enemy
		
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
	
func can_place_in_current_mode() -> bool:
	var mousePosition = get_global_mouse_position()
	
	if (mousePosition.distance_to(selectedClickable.position) > max_distance_to_connect):
		return false
	
	match ui_manager.mode:
		UIManager.MODE.FACTORY:
			return gold >= factory_price
		UIManager.MODE.PYLON:	
			return gold >= pylon_price
		UIManager.MODE.TURRET:
			return gold >= turret_price	
	return false
	
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
	cable_manager.updateFactoryConnectivity(pylon_manager.pylons, factory_manager.factories, max_distance_to_connect)

func _on_pylon_created(pylon : Pylon):
	connectClickable(pylon)
	#TODO optim func to update only a given pylon connectivity
	cable_manager.updateFactoryConnectivity(pylon_manager.pylons, factory_manager.factories, max_distance_to_connect)
	cable_manager.connectClickable(selectedClickable, pylon)
		
func _on_mode_changed():
	if ui_manager.mode == UIManager.MODE.NONE:
			selectClickable(null)
		
func _on_game_over():
	pass
	#get_tree().reload_current_scene()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		var mousePosition = get_global_mouse_position();
		
		if ui_manager.mode != UIManager.MODE.NONE:
			if hoveredClickable != null:
				selectClickable(hoveredClickable)
			
			elif selectedClickable != null:
				
				if !can_place_in_current_mode():
					return	
				
				match ui_manager.mode:
					UIManager.MODE.PYLON:
						pylon_manager.createPylon(mousePosition, max_distance_to_connect)
						gold -= pylon_price
						selectClickable(null)
						ui_manager.updateHUD(gold, factory_manager.get_gold_income_from_factories())
						
					UIManager.MODE.FACTORY:
						factory_manager.createFactory(mousePosition)
						gold -= factory_price
						selectClickable(null)
						ui_manager.updateHUD(gold, factory_manager.get_gold_income_from_factories())
						
					UIManager.MODE.TURRET:
						#TODO
						gold -= turret_price
						selectClickable(null)
						ui_manager.updateHUD(gold, factory_manager.get_gold_income_from_factories())
			
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
