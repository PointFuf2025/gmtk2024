class_name Building
extends Entity

@export var area2d : Area2D

var parent : Building  

signal destroyed(building : Building)

func setParent(newParent : Building):
	parent = newParent

func isConnected():
	return parent != null || self is Generator

func destroy():
	destroyed.emit(self)
