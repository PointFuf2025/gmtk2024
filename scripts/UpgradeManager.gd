class_name UpgradeManager

extends Node2D

#Upgrades
@export var factorySpawnRatePerLevel : float
@export var factoryIncomePerLevel : float
@export var pylonRangePerLevel : float
@export var towerRangePerLevel : float
@export var towerReloadTimePerLevel : float

#Price
@export var factorySpawnRatePrice : int
@export var factoryIncomePrice : int
@export var pylonRangePrice : int
@export var towerRangePrice : int
@export var towerReloadTimePrice : int

var factorySpawnRateLevel : int = 1
var factoryIncomeLevel : int = 1
var pylonRangeLevel : int = 1
var towerRangeLevel : int = 1
var towerReloadTimeLevel : int = 1

var factorySpawnRateCurrentPrice : int
var factoryIncomeCurrentPrice : int
var pylonRangeCurrentPrice : int
var towerRangeCurrentPrice : int
var towerReloadTimeCurrentPrice : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	factorySpawnRateCurrentPrice = factorySpawnRateLevel * factorySpawnRatePrice
	factoryIncomeCurrentPrice = factoryIncomePrice * factoryIncomeLevel
	pylonRangeCurrentPrice = pylonRangePrice * pylonRangeLevel
	towerRangeCurrentPrice = towerRangePrice * towerRangeLevel
	towerReloadTimeCurrentPrice = towerReloadTimePrice * towerReloadTimeLevel
