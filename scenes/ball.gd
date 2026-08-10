extends CharacterBody2D

@export var speed := 50.0

var direction := Vector2(-1, 0)


func _physics_process(delta):
	velocity = direction * speed

	var collision = move_and_collide(velocity * delta)

	if collision:
		direction = direction.bounce(collision.get_normal()).normalized()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		bounce_from_player(body)


func bounce_from_player(player):
	var offset = global_position.y - player.global_position.y

	var angle_degrees := 0.0

	if offset < -70:
		angle_degrees = -60
	elif offset < -25:
		angle_degrees = -30
	elif offset < 25:
		angle_degrees = 0
	elif offset < 70:
		angle_degrees = 30
	else:
		angle_degrees = 60

	var angle = deg_to_rad(angle_degrees)

	direction = Vector2(cos(angle), sin(angle)).normalized()

	# Send ball toward the boss
	direction.x = abs(direction.x)
