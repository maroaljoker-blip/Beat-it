extends Node2D

@onready var ball: CharacterBody2D = $ball

@export var original_speed := 50.0
@export var speed_increase := 10.0

var speed_timer := 0.0


func _process(delta):
	speed_timer += delta

	if speed_timer >= 5.0:
		speed_timer = 0.0
		ball.speed += speed_increase
