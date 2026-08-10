extends CharacterBody2D

@export var speed := 60.0

const TOP_LIMIT := -115.0
const BOTTOM_LIMIT := 115.0

var moving_direction := 0
var lives := 3
var dead := false


@onready var animated_sprite_2d_2: AnimatedSprite2D = $"../AnimatedSprite2D2"
@onready var animated_sprite_2d_3: AnimatedSprite2D = $"../AnimatedSprite2D3"
@onready var animated_sprite_2d_4: AnimatedSprite2D = $"../AnimatedSprite2D4"
@onready var label: Label = $"../Label"

@onready var audio_stream_player_2d = $AudioStreamPlayer2D

var can_take_hit = true
var taking_hit = false


func _ready():
	animated_sprite_2d_2.visible = true
	animated_sprite_2d_3.visible = true
	animated_sprite_2d_4.visible = true

	update_label()

	await get_tree().create_timer(3.0).timeout

	animated_sprite_2d_2.visible = false
	animated_sprite_2d_3.visible = false
	animated_sprite_2d_4.visible = false

func _physics_process(delta):

	if dead:
		velocity = Vector2.ZERO
		return

	# Press Up once
	if Input.is_action_just_pressed("move up"):
		moving_direction = -1

	# Press Down once
	if Input.is_action_just_pressed("move down"):
		moving_direction = 1

	# Move continuously
	velocity.y = moving_direction * speed
	move_and_slide()

	# Stop at the limits
	if position.y <= TOP_LIMIT:
		position.y = TOP_LIMIT
		moving_direction = 0

	if position.y >= BOTTOM_LIMIT:
		position.y = BOTTOM_LIMIT
		moving_direction = 0


func update_label():
	label.text = "Lives: " + str(lives)

	match lives:
		3:
			animated_sprite_2d_2.play("full")
			animated_sprite_2d_3.play("full")
			animated_sprite_2d_4.play("full")

		2:
			animated_sprite_2d_2.play("empty")
			animated_sprite_2d_3.play("full")
			animated_sprite_2d_4.play("full")

		1:
			animated_sprite_2d_2.play("empty")
			animated_sprite_2d_3.play("empty")
			animated_sprite_2d_4.play("full")

		0:
			animated_sprite_2d_2.play("empty")
			animated_sprite_2d_3.play("empty")
			animated_sprite_2d_4.play("empty")


func show_lives_after_hit():
	animated_sprite_2d_2.visible = true
	animated_sprite_2d_3.visible = true
	animated_sprite_2d_4.visible = true

	await get_tree().create_timer(3.0).timeout

	animated_sprite_2d_2.visible = false
	animated_sprite_2d_3.visible = false
	animated_sprite_2d_4.visible = false


func die():
	dead = true
	moving_direction = 0
	velocity = Vector2.ZERO

	audio_stream_player_2d.play()

	await audio_stream_player_2d.finished

	get_tree().reload_current_scene()


func _on_damage_area_body_entered(body: Node2D) -> void:
	print(body.name)
	if body.name == "ball" or body.name == "nemo":
		
		if not can_take_hit:
			return

		taking_hit = true
		can_take_hit = false

		if body.name == "nemo":
			lives -= 2
		else:
			lives -= 1

		update_label()

		if lives <= 0:
			die()
			return

		# Show the three life sprites for 3 seconds
		show_lives_after_hit()

		taking_hit = false
		can_take_hit = true
