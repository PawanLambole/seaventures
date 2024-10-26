extends Node3D

@onready var level = $"../"
@export var speed = 10

# Move modules and free them when offscreen
func _physics_process(delta):
	position.x -= speed * delta
	if position.x < -15:
		level.spawn_module(position.x + (level.amnt * level.offset))
		queue_free()
