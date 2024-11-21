extends Node2D

@onready var lbl_power = $ui/lbl_power
@onready var lbl_player = $ui/lbl_player
@onready var lbl_score = $ui/lbl_score
@onready var player = $Reimu

func get_items():
	var res = []
	for child in get_children():
		if child.is_in_group("item"):
			res.append(child)
	return res

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player.is_power_max():
		lbl_power.text = "Power : MAX"
	else:
		lbl_power.text = "Power : " + str(player.power) + " /4.0"
	lbl_score.text = "Score : " + str(player.score)
	lbl_player.text = "Player : " + str(player.lives)

func instantiate_item(item, item_pos):
	add_child(item)
	item.global_position = item_pos


func _on_item_swallow_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and player.is_power_max():
		for child in get_children():
			if child.is_in_group("item"):
				child.player = player
				child.following = true
