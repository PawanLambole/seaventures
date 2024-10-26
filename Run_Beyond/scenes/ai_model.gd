extends Node

# Signals for increasing and decreasing difficulty
signal increase_obstacle_frequency
signal decrease_obstacle_frequency

@export var interval: float = 5.0 # Time interval to check performance
@export var frequency_increase_rate: float = 0.1
@export var frequency_decrease_rate: float = 0.1
@export var speed_increase_rate: float = 1.0
@export var speed_decrease_rate: float = 0.5

var timer: Timer
var player_performance: float = 0 # Performance metric
var performance_tracker: Node

func _ready():
	# Initialize timer to check performance
	timer = Timer.new()
	timer.wait_time = interval
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_adjust_difficulty"))
	add_child(timer)
	timer.start()

	# Reference to performance tracker
	performance_tracker = get_node("/root/PlayerPerformance")

func _adjust_difficulty():
	# Get the player's performance
	player_performance = performance_tracker.get_player_performance()
	
	# Adjust difficulty based on performance
	if player_performance > 0.7:
		emit_signal("increase_obstacle_frequency")
	elif player_performance < 0.4:
		emit_signal("decrease_obstacle_frequency")
