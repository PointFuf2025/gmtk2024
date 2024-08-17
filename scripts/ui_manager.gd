class_name UIManager
extends CanvasLayer

@export var goldLabel : Label
@export var gainPerSecondLabel : Label

func updateHUD(gold : int, goldPerSecond : int) -> void:
	goldLabel.text = str(gold)
	gainPerSecondLabel.text = "(+ %s)" % str(goldPerSecond)
