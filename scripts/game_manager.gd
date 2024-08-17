extends Node2D

@export var generatorPackedScene : PackedScene

@export var factory_manager : Factory_manager
@export var cable_manager : Cable_manager
@export var pylon_manager : Pylon_manager

var generator : Generator
var hoveredClickable : Clickable
var selectedClickable : Clickable


const _spawn_speed: float = 1.0 / 5.0 
var _spawns_quantity: float # For tracking the quantity
							# to spawn over time


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
	
func _process(delta: float) -> void:
	 # Increase spawns quantity over time
	_spawns_quantity += delta * _spawn_speed
	# Check if something to spawn
	if _spawns_quantity >= 1:
		var randomAngle = randf_range(0, 2 * PI)
		var randomDistance = randf_range(0.8, 1) * 1000
		var randomPosition = generator.position + (Vector2.RIGHT * randomDistance).rotated(randomAngle)
		factory_manager.createFactory(randomPosition)
		_spawns_quantity = 0

	
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
			selectedClickable = hoveredClickable
			selectedClickable.isSelected = true
		elif selectedClickable != null:
			pylon_manager.createPylon(mousePosition)
			selectedClickable.isSelected = false
			selectedClickable = null
			hoveredClickable = null
	
