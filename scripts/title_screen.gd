extends Node2D

@onready var buttons = $buttonSet

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		match buttons.get_selected_id():
			"play": get_tree().change_scene_to_file("res://scenes/stage.tscn")
			"quit": get_tree().quit()
