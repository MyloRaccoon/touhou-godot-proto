extends Node2D

@onready var lbl_power = $ui/lbl_power
@onready var lbl_player = $ui/lbl_player
@onready var lbl_score = $ui/lbl_score
@onready var player = $Reimu

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player.is_power_max():
		lbl_power.text = "Power : MAX"
	else:
		lbl_power.text = "Power : " + str(player.power) + " /4.0"
	lbl_score.text = "Score : " + str(player.score)
	lbl_player.text = "Player : " + str(player.lives)
