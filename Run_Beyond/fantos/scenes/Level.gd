extends Node3D

@export var modules: Array[PackedScene] = []
var amnt = 30
var rng = RandomNumberGenerator.new()
var offset = 6
var initObs = 0
var obstacle_frequency: float = 1.0
var speed: float = 10.0

func _ready():
	# Connect AIModel signals to adjust difficulty
	for n in range(amnt):
		spawn_module(n * offset)
	
	AIModel.connect("decrease_obstacle_frequency", Callable(self, "_decrease_obstacle_variety"))
	AIModel.connect("increase_obstacle_frequency", Callable(self, "_increase_obstacle_variety"))
	
	

func spawn_module(n):
	if initObs > 5:
		rng.randomize()
		var num = rng.randi_range(0,modules.size()-1)
		var instance = modules[num].instantiate()
		instance.position.x = n
		add_child(instance)
	else:
		var instance = modules[0].instantiate()
		instance.position.x = n
		add_child(instance)
		initObs += 1

func _increase_obstacle_variety():
	obstacle_frequency += AIModel.frequency_increase_rate
	speed += AIModel.speed_increase_rate
	for n in range(amnt):
		spawn_module(n * offset * obstacle_frequency)

func _decrease_obstacle_variety():
	obstacle_frequency = max(1.0, obstacle_frequency - AIModel.frequency_decrease_rate)
	speed = max(5.0, speed - AIModel.speed_decrease_rate)
	for n in range(amnt):
		spawn_module(n * offset * obstacle_frequency)
