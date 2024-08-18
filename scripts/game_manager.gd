class_name GameManager
extends Node2D

@export var generatorPackedScene : PackedScene

@export_group("Managers")
@export var factory_manager : Factory_manager
@export var cable_manager : Cable_manager
@export var pylon_manager : Pylon_manager
@export var enemy_manager : EnemyManager
@export var turret_manager : TurretManager
@export var ui_manager : UIManager
@export var camera : Camera

@export_group("Factory") 
@export var factoryCountAtStart : float
@export var factorySpawnIntervall : float
@export var factorySpawnRadiusBase : float
@export var factorySpawnRadiusDelta : float
@export var factorySpawnRadiusPerSecond : float

@export_group("Enemy") 
@export var isEnemyEnabled : bool
@export var enemySpawnRangeBase : float
@export var enemySpawnRangeGainPerSecond : float
@export var enemySpawnIntervallOverTime : Curve
@export var enemySpawnIntervallMultiplierOverTime : Curve
var enemySpawnRange : float

@export_group("Entity") 
@export var max_distance_to_connect : float
@export var minimal_distance_between_building : float
@export var pylon_price : int
@export var turret_price : int
@export var factory_price : int

@export_group("Ghost")
@export var ghost_pylon : Ghost
 
var factorySpawnRadius : float
var timeToIncome : float
var timeToSpawnFactory : float
var timeToSpawnEnemy : float
var timeSinceStart : float
var gold : float

var generator : Generator
var hoveredClickable : ClickableBuilding
			
# for now just let game manager start with ready
func _ready() -> void:
	# create and add the generator
	gold = 10
	timeSinceStart = 0
	timeToSpawnEnemy = enemySpawnIntervallOverTime.sample(0)
	timeToSpawnFactory = factorySpawnIntervall
	enemySpawnRange = enemySpawnRangeBase
	factorySpawnRadius = factorySpawnRadiusBase
	
	generator = generatorPackedScene.instantiate() as Generator
	generator.position = DisplayServer.screen_get_size() / 2
	generator.radius = max_distance_to_connect
	connectClickable(generator)
	add_child(generator)
	
	factory_manager.factoryCreated.connect(_on_factory_created)
	factory_manager.factoryDestroyed.connect(_on_factory_destroyed)
	
	pylon_manager.pylonCreated.connect(_on_pylon_created)
	pylon_manager.pylonDestroyed.connect(_on_pylon_destroyed)
	
	turret_manager.turretCreated.connect(_on_turret_created)
	turret_manager.turretDestroyed.connect(_on_turret_destroyed)
	
	generator.generatorDestroyed.connect(_on_generator_destroyed)
	
	ui_manager.setTurretPrices(turret_price, pylon_price, factory_price)
	
	for i in range(factoryCountAtStart):
		var randomAngle = randf_range(0, 2 * PI)
		var randomDistance = factorySpawnRadius + randf() * factorySpawnRadiusDelta
		var randomPosition = generator.position + (Vector2.RIGHT * randomDistance).rotated(randomAngle)
		
		factory_manager.createFactory(randomPosition)
	
	camera.global_position = generator.global_position
	camera.limit_left += generator.global_position.x
	camera.limit_right += generator.global_position.x
	camera.limit_top += generator.global_position.y
	camera.limit_bottom += generator.global_position.y
		
func _process(delta: float) -> void:
	process_factory_spawn(delta)
	process_enemy_spawn(delta)
	process_factory_income(delta)
	
	if ui_manager.mode != UIManager.MODE.NONE:
		var canPlace = can_place_in_current_mode()
		ghost_pylon.update(get_global_mouse_position(), get_global_mouse_position(), ui_manager.mode, canPlace, max_distance_to_connect)
	else:
		ghost_pylon.hideGhost()
		
	timeSinceStart += delta

func process_factory_spawn(delta : float) -> void:
	
	factorySpawnRadius += factorySpawnRadiusPerSecond * delta
	
	if timeToSpawnFactory < 0:
	
		var randomAngle = randf_range(0, 2 * PI)
		var randomDistance = factorySpawnRadius + randf() * factorySpawnRadiusDelta
		var randomPosition = generator.position + (Vector2.RIGHT * randomDistance).rotated(randomAngle)

		factory_manager.createFactory(randomPosition)
		timeToSpawnFactory = randf_range(0.8, 1.2) * factorySpawnIntervall
		
	timeToSpawnFactory -= delta

func process_enemy_spawn(delta : float) -> void:
	
	if !isEnemyEnabled:
		return
	
	enemySpawnRange = 3000 # spawnRange_increasePerSecond * delta	
	if timeToSpawnEnemy < 0:
		var randomAngle = randf_range(0, 2 * PI)
		var randomDistance = randf_range(0.8, 1) * enemySpawnRange
		var randomPosition = generator.position + (Vector2.RIGHT * randomDistance).rotated(randomAngle)
		
		enemy_manager.createEnemy(randomPosition, factory_manager.factories, pylon_manager.pylons, generator)
		
		var normalizedTimeSinceStart : float = clamp(timeSinceStart / (2 * 60), 0, 1)
		var moduloTimeSinceStart : float = (floori(10 * timeSinceStart) % 50) / 50.0
		
		timeToSpawnEnemy = enemySpawnIntervallOverTime.sample(normalizedTimeSinceStart) * enemySpawnIntervallMultiplierOverTime.sample(moduloTimeSinceStart)
		
	timeToSpawnEnemy -= delta
	
func process_factory_income(delta : float) -> void:
	if timeToIncome <0:
		var goldIncomePerSecond = factory_manager.get_gold_income_from_factories();
		gold += goldIncomePerSecond
		timeToIncome = 1;
		ui_manager.updateHUD(gold, goldIncomePerSecond)
		
	timeToIncome -= delta
	
func can_place_in_current_mode() -> bool:
	match ui_manager.mode:
		UIManager.MODE.FACTORY:
			if gold < factory_price:
				return false
				
		UIManager.MODE.PYLON:	
			if gold < pylon_price:
				return false
				
		UIManager.MODE.TURRET:
			if gold < turret_price:
				return false
	
	var mousePosition = get_global_mouse_position()
	
	if generator.global_position.distance_to(mousePosition) < minimal_distance_between_building:
			return false
			
	for pylon in pylon_manager.pylons:
		if pylon.global_position.distance_to(mousePosition) < minimal_distance_between_building:
			return false

	for turret in turret_manager.turrets:
		if turret.global_position.distance_to(mousePosition) < minimal_distance_between_building:
			return false
	
	for factory in factory_manager.factories:
		if factory.global_position.distance_to(mousePosition) < minimal_distance_between_building:
			return false
			
	return true
	
func connectClickable(clickable : ClickableBuilding):
	clickable.hovered.connect(_on_clickable_hovered)

func _on_clickable_hovered(newHoveredClickable : ClickableBuilding, state : bool) -> void:		
	if state:
		if hoveredClickable == null:
			hoveredClickable = newHoveredClickable
	else:
		if hoveredClickable == newHoveredClickable:
			hoveredClickable = null
			
func _on_factory_created():
	cable_manager.updateCables(generator, pylon_manager.pylons, factory_manager.factories, turret_manager.turrets, max_distance_to_connect)

func _on_factory_destroyed():
	cable_manager.updateCables(generator, pylon_manager.pylons, factory_manager.factories, turret_manager.turrets, max_distance_to_connect)

func _on_pylon_created(pylon : Pylon):
	connectClickable(pylon)
	cable_manager.updateCables(generator, pylon_manager.pylons, factory_manager.factories, turret_manager.turrets, max_distance_to_connect)

func _on_pylon_destroyed():
	cable_manager.updateCables(generator, pylon_manager.pylons, factory_manager.factories, turret_manager.turrets, max_distance_to_connect)
	
func _on_turret_created():
	cable_manager.updateCables(generator, pylon_manager.pylons, factory_manager.factories, turret_manager.turrets, max_distance_to_connect)
		
func _on_turret_destroyed():
	cable_manager.updateCables(generator, pylon_manager.pylons, factory_manager.factories, turret_manager.turrets, max_distance_to_connect)

func _on_generator_destroyed():
	#TODO game over
	get_tree().reload_current_scene()
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		var mousePosition = get_global_mouse_position();
		
		if ui_manager.mode != UIManager.MODE.NONE:
			if !can_place_in_current_mode():
				return	
				
		match ui_manager.mode:
			UIManager.MODE.PYLON:
				pylon_manager.createPylon(mousePosition, max_distance_to_connect)
				gold -= pylon_price
				ui_manager.updateHUD(gold, factory_manager.get_gold_income_from_factories())
				
			UIManager.MODE.FACTORY:
				factory_manager.createFactory(mousePosition)
				gold -= factory_price
				ui_manager.updateHUD(gold, factory_manager.get_gold_income_from_factories())
				
			UIManager.MODE.TURRET:
				turret_manager.createTurret(mousePosition, enemy_manager.enemies)
				gold -= turret_price
				ui_manager.updateHUD(gold, factory_manager.get_gold_income_from_factories())
			
	elif event.is_action_pressed("cancel"):
		ui_manager.mode = UIManager.MODE.NONE
		ui_manager.ModeChanged.emit()
