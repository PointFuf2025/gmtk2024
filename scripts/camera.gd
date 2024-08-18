class_name Camera
extends Camera2D

@export var movementSpeed : float
@export var zoomSpeed : float
@export var zoomMin : float
@export var zoomMax : float

var movementDirection : Vector2 = Vector2.ZERO
var zoomDirection : float = 0
var zoomHadInput : bool = false

var isRightDown : bool
var isLeftDown : bool
var lastPressedIsLeft : bool

var isUpDown : bool
var isDownDown : bool
var lastPressedIsUp : bool

func _process(delta: float) -> void:
	var movementSpeedScaledOnZoom = movementSpeed / zoom.x
	position +=	 movementDirection * movementSpeedScaledOnZoom * delta
	
	var newZoom = zoom.x + zoomDirection * zoomSpeed * delta
	zoom = Vector2.ONE * clamp(newZoom, zoomMin, zoomMax)	
	
	if !zoomHadInput:
		zoomDirection *= 0.5;
		
	zoomHadInput = false
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_left"):
		isLeftDown = true
		lastPressedIsLeft = true
	elif event.is_action_released("camera_left"):
		isLeftDown = false
	
	if event.is_action_pressed("camera_right"):
		isRightDown = true
		lastPressedIsLeft = false
	elif event.is_action_released("camera_right"):
		isRightDown = false
		
	if event.is_action_pressed("camera_up"):
		isUpDown = true
		lastPressedIsUp = true
	elif event.is_action_released("camera_up"):
		isUpDown = false
		
	if event.is_action_pressed("camera_down"):
		isDownDown = true
		lastPressedIsUp = false
	elif event.is_action_released("camera_down"):
		isDownDown = false
			
	if isLeftDown && isRightDown:
		movementDirection.x = -1 if lastPressedIsLeft else 1
	elif isLeftDown:
		movementDirection.x = -1
	elif isRightDown:
		movementDirection.x = 1
	else:
		movementDirection.x = 0
		
	if isLeftDown && isRightDown:
		movementDirection.y = -1 if lastPressedIsUp else 1
	elif isUpDown:
		movementDirection.y = -1
	elif isDownDown:
		movementDirection.y = 1
	else:
		movementDirection.y = 0
		
	if event.is_action_released("camera_zoom_in"):
		zoomDirection = clamp(max(zoomDirection, 0) + 0.1, 0, 1)
		zoomHadInput = true
	elif event.is_action_released("camera_zoom_out"):
		zoomDirection = clamp(min(zoomDirection, 0) - 0.1, -1, 0)
		zoomHadInput = true
