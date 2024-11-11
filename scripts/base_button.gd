class_name baseButton
extends Node2D

@export var id : String

var is_selected = false

#func get_class():
	#return "baseButton"
#
#func is_class(value):
	#return value == "baseButton"

func select(boolean):
	is_selected = boolean
	update_sprite()

func update_sprite():
	if is_selected:
		scale = Vector2(1.5, 1.5)
		modulate = Color8(modulate.r8, modulate.g8, modulate.b8, 255)
	else:
		scale = Vector2(1, 1)
		modulate = Color8(modulate.r8, modulate.g8, modulate.b8, 100)
