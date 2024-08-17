extends Node2D

@export var generatorPackedScene : PackedScene
@export var pylgonPackedScene : PackedScene

@export var pylonRadius : float

var generator : Generator
var hoveredClickable : Clickable
var selectedClickable : Clickable
var pylons : Array[Pylon]

# for now just let game manager start with ready
func _ready() -> void:
	
	# create and add the generator
	generator = generatorPackedScene.instantiate() as Generator
	generator.position = DisplayServer.screen_get_size() / 2
	connectClickable(generator)
	add_child(generator)
	
func _process(delta: float) -> void:
	var mousePosition = get_viewport().get_mouse_position()
	print(mousePosition)

func createPylon(position : Vector2) -> void:
	var newPylon = pylgonPackedScene.instantiate() as Pylon;
	newPylon.position = position
	newPylon.radius = pylonRadius
	connectClickable(newPylon)
	
	pylons.append(newPylon)		
	
	add_child(newPylon)
	
	print("pylon created at " + str(position))
	
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
		var mousePosition = get_viewport().get_mouse_position()
		
		if hoveredClickable != null:
			selectedClickable = hoveredClickable
		elif selectedClickable != null:
			createPylon(mousePosition)
			selectedClickable = null
			hoveredClickable = null
		
