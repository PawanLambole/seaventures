extends CharacterBody3D

@onready var death_sensor = $DeathSensor

var positions = [-3, 0, 3] # Possible lane positions
var curPos = 1 # Current lane position
const JUMP_VEL = 7
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var performance_tracker: Node

func _ready():
	performance_tracker = get_node("/root/PlayerPerformance") # Reference the performance tracker

func _process(delta):
	handle_input()

	# Move character between lanes smoothly
	position.z = lerpf(position.z, positions[curPos], delta * 10)

	# Check if player collides with death sensor
	if death_sensor.is_colliding():
		death()

	# Apply gravity and move character
	velocity.y -= gravity * delta
	move_and_slide()

func handle_input():
	# Lateral movement
	if Input.is_action_just_pressed("ui_right"):
		if curPos < 2: # Move to the right lane
			curPos += 1
			performance_tracker.record_lane_change() # Notify tracker of lane change
	elif Input.is_action_just_pressed("ui_left"):
		if curPos > 0: # Move to the left lane
			curPos -= 1
			performance_tracker.record_lane_change() # Notify tracker of lane change

	# Jumping (only if on the ground)
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_accept"): 
		if is_on_floor():
			velocity.y = JUMP_VEL

func death():
	get_tree().change_scene_to_file("res://control.tscn")
