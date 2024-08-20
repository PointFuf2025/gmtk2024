class_name Generator
extends ClickableBuilding

signal generatorDestroyed()

func _ready() -> void:
	super._ready()
	destroyed.connect(_on_generator_destoyed)

func _on_generator_destoyed(building : Building):
	generatorDestroyed.emit()
