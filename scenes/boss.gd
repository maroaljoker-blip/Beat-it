extends CharacterBody2D

@export var speed := 150
@export var mistake_chance := 0.20
@export var mistake_delay := 0.4

@onready var ball: CharacterBody2D = $"../ball"

const TOP_LIMIT := -115.0
const BOTTOM_LIMIT := 115.0

var target_y := 0.0
var mistake_timer := 0.0


func _ready():
	target_y = ball.global_position.y


func _physics_process(delta):
	# Count down the mistake timer
	if mistake_timer > 0:
		mistake_timer -= delta

	# Choose a new target
	if mistake_timer <= 0:
		target_y = ball.global_position.y

		# Sometimes the boss reacts late
		if randf() < mistake_chance:
			mistake_timer = mistake_delay

	# Move smoothly toward the target
	position.y = move_toward(
		position.y,
		target_y,
		speed * delta
	)

	position.y = clamp(
		position.y,
		TOP_LIMIT,
		BOTTOM_LIMIT
	)
