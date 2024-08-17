extends Node2D

@export var generatorPackedScene : PackedScene
@export var pylgonPackedScene : PackedScene
@export var cablePackedScene : PackedScene
@export var factoryPackedScene : PackedScene

@export var cableRoot : Node2D
@export var factoryRoot : Node2D
@export var pylonRoot : Node2D

var cableArray: Array[Cable]
var factoryArray: Array[Factory]

@export var pylonRadius : float

var generator : Generator
var hoveredClickable : Clickable
var selectedClickable : Clickable
var pylonArray : Array[Pylon]

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
	
func _process(delta: float) -> void:
	 # Increase spawns quantity over time
	_spawns_quantity += delta * _spawn_speed
	# Check if something to spawn
	if _spawns_quantity >= 1:
		var randomAngle = randf_range(0, 2 * PI)
		var randomDistance = randf_range(0.8, 1) * 1000
		var randomPosition = generator.position + (Vector2.RIGHT * randomDistance).rotated(randomAngle)
		
		createFactory(randomPosition)
		_spawns_quantity = 0

func createPylon(position : Vector2) -> void:
	var newPylon = pylgonPackedScene.instantiate() as Pylon;
	newPylon.position = position
	newPylon.radius = pylonRadius
	connectClickable(newPylon)
	
	pylonArray.append(newPylon)		
	# bug if a factory spawn after this will not connect
	add_child(newPylon)
	updateFactoryConnectivity()
	
	print("pylon created at " + str(position))
	
func createFactory(position: Vector2) -> void:
	var factory = factoryPackedScene.instantiate() as Factory
	factory.position = position
	factoryRoot.add_child(factory)
	factoryArray.append(factory)
	updateFactoryConnectivity()
	
func connectClickable(clickable : Clickable):
	clickable.hovered.connect(_on_clickable_hovered)
	
func _on_clickable_hovered(newHoveredClickable : Clickable, state : bool) -> void:		
	if state:
		if hoveredClickable == null:
			hoveredClickable = newHoveredClickable
	else:
		if hoveredClickable == newHoveredClickable:
			hoveredClickable = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		var mousePosition = get_global_mouse_position();
		
		if hoveredClickable != null:
			selectedClickable = hoveredClickable
		elif selectedClickable != null:
			createPylon(mousePosition)
			selectedClickable = null
			hoveredClickable = null
		
func updateFactoryConnectivity():
	var cable : Cable
	for pylon in pylonArray:
		for factory in factoryArray:
			var isInside: bool = pylon.global_position.distance_to(factory.global_position) < pylon.radius
			if isInside && !factory.isConnected: 
				cable = cablePackedScene.instantiate()
				cable.connectCable(pylon.global_position, factory.global_position)
				cableArray.append(cable)
				cableRoot.add_child(cable)
				factory.isConnected = true
	
