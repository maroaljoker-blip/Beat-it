extends Node2D

@onready var button: Button = $Button

func _process(delta):
	if Input.is_action_just_pressed("Start"):
		button.emit_signal("pressed")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game_2.tscn")
