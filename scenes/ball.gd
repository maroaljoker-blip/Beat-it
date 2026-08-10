extends CharacterBody2D

@export var speed := 100

var direction := Vector2(-1, 0)
const LEFT_LIMIT := -77.0
const RIGHT_LIMIT := 502.0

func _physics_process(delta):
	velocity = direction * speed

	var collision = move_and_collide(velocity * delta)

	if collision:
		direction = direction.bounce(collision.get_normal()).normalized()

	if global_position.x <= LEFT_LIMIT:
		reset_ball()

	elif global_position.x >= RIGHT_LIMIT:
		reset_ball()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		bounce_from_paddle(body, true)

	elif body.name == "boss":
		bounce_from_paddle(body, false)


func bounce_from_paddle(paddle, is_player):
	var offset = global_position.y - paddle.global_position.y

	# Convert the hit position into a value from -1 to 1
	var paddle_half_height = 115.0
	var hit = clamp(offset / paddle_half_height, -1.0, 1.0)


	# Maximum bounce angle
	var angle = hit * deg_to_rad(60.0)

	var new_direction = Vector2(cos(angle), sin(angle)).normalized()

	if is_player:
		# Player is on the left → go right
		new_direction.x = abs(new_direction.x)
	else:
		# Boss is on the right → go left
		new_direction.x = -abs(new_direction.x)

	direction = new_direction
func reset_ball():
	global_position = Vector2(212, 0)
	direction = Vector2(1, 0)
