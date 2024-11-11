extends Node2D

@export_enum("VERTICAL", "HORIZONTAL") var align
var positive_btn
var negative_btn

@onready var buttons = get_buttons()
var selected_id = 0
var is_active = true

func _ready() -> void:
	if align == 0:
		positive_btn = "ui_down"
		negative_btn = "ui_up"
	else:
		positive_btn = "ui_right"
		negative_btn = "ui_left"
	update_select()

func get_buttons():
	var res = []
	for child in get_children():
		if child is baseButton:
			res.append(child)
	return res

func update_select():
	unselect()
	buttons[selected_id].select(true)

func unselect():
	for button in buttons:
		button.select(false)

func activate(boolean):
	is_active = boolean
	if is_active:
		update_select()
	else:
		unselect()

func get_selected_id():
	return buttons[selected_id].id

func _input(event: InputEvent) -> void:
	if is_active:
		if event.is_action_pressed(negative_btn) and selected_id > 0:
			selected_id -= 1
			update_select()
		if event.is_action_pressed(positive_btn) and selected_id < len(buttons)-1:
			selected_id += 1
			update_select()
