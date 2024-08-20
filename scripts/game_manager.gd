class_name GameManager
extends Node2D

@export var generatorPackedScene : PackedScene

@export_group("Managers")
@export var factory_manager : Factory_manager
@export var cable_manager : Cable_manager
@export var pylon_manager : Pylon_manager
@export var enemy_manager : EnemyManager
@export var turret_manager : TurretManager
@export var upgrade_manager : UpgradeManager
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

@export var gameOverCanvasLayer : CanvasLayer
@export var gameOverTimer : Timer
@export var gameOverSoundEffect : AudioStream
@export var audioStreamPlayer : AudioStreamPlayer

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
	gold = 30
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
	factory_manager.incomeGained.connect(_on_factory_income_gained)
	
	pylon_manager.pylonCreated.connect(_on_pylon_created)
	pylon_manager.pylonDestroyed.connect(_on_pylon_destroyed)
	
	turret_manager.turretCreated.connect(_on_turret_created)
	turret_manager.turretDestroyed.connect(_on_turret_destroyed)
	
	generator.generatorDestroyed.connect(_on_generator_destroyed)
	
	ui_manager.setTurretPrices(turret_price, pylon_price, factory_price)
	
	#Upgrades
	ui_manager.pylonRangeUpgrade.button_up.connect(_on_pylon_range_clicked)
	ui_manager.towerReloadTimeUpgrade.button_up.connect(_on_tower_reload_clicked)
	ui_manager.towerRangeUpgrade.button_up.connect(_on_tower_range_clicked)
	ui_manager.factoryIncomeUpgrade.button_up.connect(_on_factory_income_clicked)
	ui_manager.factorySpawnUpgrade.button_up.connect(_on_factory_spawn_clicked)
	
	for i in range(factoryCountAtStart):
		
		var randomPosition
		var isPositionValid = false
		while !isPositionValid:
			var randomAngle = randf_range(0, 2 * PI)
			var randomDistance = factorySpawnRadius + randf() * factorySpawnRadiusDelta
			randomPosition = generator.position + (Vector2.RIGHT * randomDistance).rotated(randomAngle)
			isPositionValid = is_position_valid_for_building(randomPosition, 500)
		
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
	
	
	ui_manager.setUpgradePrices(upgrade_manager.towerRangeCurrentPrice, upgrade_manager.towerReloadTimeCurrentPrice, upgrade_manager.pylonRangeCurrentPrice, upgrade_manager.factoryIncomeCurrentPrice, upgrade_manager.factorySpawnRateCurrentPrice, gold)
	
	if ui_manager.mode != UIManager.MODE.NONE:
		var canPlace = can_place_in_current_mode()
		ghost_pylon.update(get_global_mouse_position(), get_global_mouse_position(), ui_manager.mode, canPlace, max_distance_to_connect)
	else:
		ghost_pylon.hideGhost()
		
	timeSinceStart += delta

func process_factory_spawn(delta : float) -> void:
	
	factorySpawnRadius += factorySpawnRadiusPerSecond * delta
	
	if timeToSpawnFactory < 0:
	
		var randomPosition
		var isPositionValid = false
		while !isPositionValid:
			var randomAngle = randf_range(0, 2 * PI)
			var randomDistance = factorySpawnRadius + randf() * factorySpawnRadiusDelta
			randomPosition = generator.position + (Vector2.RIGHT * randomDistance).rotated(randomAngle)
			isPositionValid = is_position_valid_for_building(randomPosition, 500)

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
		
		enemy_manager.createEnemy(randomPosition, factory_manager.factories, pylon_manager.pylons, turret_manager.turrets, generator)
		
		var normalizedTimeSinceStart : float = clamp(timeSinceStart / (2 * 60), 0, 1)
		var moduloTimeSinceStart : float = (floori(10 * timeSinceStart) % 50) / 50.0
		
		timeToSpawnEnemy = enemySpawnIntervallOverTime.sample(normalizedTimeSinceStart) * enemySpawnIntervallMultiplierOverTime.sample(moduloTimeSinceStart)
		
	timeToSpawnEnemy -= delta
	
func process_factory_income(delta : float) -> void:
	ui_manager.updateHUD(gold)
	
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
	
	return is_position_valid_for_building(mousePosition, minimal_distance_between_building)

func is_position_valid_for_building(position : Vector2, distance : float):
	
	if generator.global_position.distance_to(position) < distance:
			return false
			
	if !pylon_manager.is_position_available_for_building(position, distance):
			return false

	if !turret_manager.is_position_available_for_building(position, distance):
			return false
	
	if !factory_manager.is_position_available_for_building(position, distance):
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

func _on_factory_income_gained(income : int):
	gold += income

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
	audioStreamPlayer.stream = gameOverSoundEffect
	audioStreamPlayer.play()
	gameOverCanvasLayer.visible = true
	gameOverTimer.timeout.connect(_on_gameover_timer_timeout)
	gameOverTimer.start()

func _on_gameover_timer_timeout():
	get_tree().reload_current_scene()

# Upgrades callbacks
func _on_pylon_range_clicked():
	var cost = upgrade_manager.pylonRangeCurrentPrice
	if gold >= cost:
		gold -= cost
		#pylon_manager.updatePylonStats(upgrade_manager.pylonRangeLevel * upgrade_manager.pylonRangePerLevel)
		max_distance_to_connect += upgrade_manager.pylonRangePerLevel
		upgrade_manager.pylonRangeLevel += 1

func _on_tower_range_clicked():
	var cost = upgrade_manager.towerRangeCurrentPrice
	if gold >= cost:
		gold -= cost
		turret_manager.updateTurretStats(0, upgrade_manager.towerRangePerLevel)
		upgrade_manager.towerRangeLevel += 1

func _on_tower_reload_clicked():
	var cost = upgrade_manager.towerReloadTimeCurrentPrice
	if gold >= cost:
		gold -= cost
		turret_manager.updateTurretStats(upgrade_manager.towerReloadTimePerLevel, 0)
		upgrade_manager.towerReloadTimeLevel += 1

func _on_factory_income_clicked():
	var cost = upgrade_manager.factoryIncomeCurrentPrice
	if gold >= cost:
		gold -= cost
		factory_manager.updateFactoryStats(upgrade_manager.factoryIncomePerLevel)
		upgrade_manager.factoryIncomeLevel += 1

func _on_factory_spawn_clicked():
	var cost = upgrade_manager.factorySpawnRateCurrentPrice
	if gold >= cost:
		gold -= cost
		factorySpawnIntervall -= upgrade_manager.factorySpawnRatePerLevel
		upgrade_manager.factorySpawnRateLevel += 1
			
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		var mousePosition = get_global_mouse_position();
		
		if ui_manager.mode != UIManager.MODE.NONE:
			if !can_place_in_current_mode():
				return	
				
		match ui_manager.mode:
			UIManager.MODE.PYLON:
				pylon_manager.createPylon(mousePosition, max_distance_to_connect)
				gold -= pylon_price
				ui_manager.updateHUD(gold)
				
			UIManager.MODE.FACTORY:
				factory_manager.createFactory(mousePosition)
				gold -= factory_price
				ui_manager.updateHUD(gold)
				
			UIManager.MODE.TURRET:
				turret_manager.createTurret(mousePosition, enemy_manager.enemies)
				gold -= turret_price
				ui_manager.updateHUD(gold)
			
	elif event.is_action_pressed("cancel"):
		ui_manager.mode = UIManager.MODE.NONE
		ui_manager.ModeChanged.emit()
