extends Node

var player: Node3D
var total_time: float = 0.0
var jumps: int = 0
var lane_changes: int = 0

func _ready():
	player = get_node("/root/MainScene/Player") # Adjust path if necessary
	set_process(true)

func _process(delta):
	total_time += delta
	# Example metric: Track when the player jumps or changes lanes
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_accept"):
		jumps += 1

func get_player_performance() -> float:
	# Custom logic to calculate performance (e.g. based on jumps and lane changes)
	var performance = (jumps + lane_changes) / total_time
	return clamp(performance, 0.0, 1.0)

# Call this from player.gd whenever player changes lanes
func record_lane_change():
	lane_changes += 1
