extends Node2D

@export var generatorPackedScene : PackedScene

var generator : Node2D

# for now just let game manager start with ready
func _ready() -> void:
	
	# create and add the generator
	generator = generatorPackedScene.instantiate()	
	generator.position = DisplayServer.screen_get_size() / 2;
	
	add_child(generator)
	
