extends CharacterBody2D
class_name Item

@export var from_ceilling : bool

enum states {SPAWNING, FALLING, FOLLOWING}

const SPAWNING_SPD = 500
const FALLING_SPD = 150
var FRAME_FALL = randi_range(1, 15)

var speed
var direction : Vector2

var frame = 0

var state = states.SPAWNING

var player

func get_following_speed():
	if player != null:
		return player.max_speed + 100
	return 800

func _ready() -> void:
	if from_ceilling:
		position = Vector2(256, -54)
		fall()
	else:
		spawn()

func _physics_process(_delta: float) -> void:
	if state != states.FOLLOWING:
		check_following()
		if state == states.SPAWNING:
			frame += 1
			if frame > FRAME_FALL:
				fall()
		elif state == states.FALLING and speed < FALLING_SPD:
			speed += 2
	else:
		set_dir_to_player()

	velocity = speed * direction

	move_and_slide()

func spawn():
	state = states.SPAWNING
	speed = SPAWNING_SPD
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 0)).normalized()

func fall():
	state = states.FALLING
	speed = 0
	direction = Vector2.DOWN

func follow():
	state = states.FOLLOWING

func set_dir_to_player():
	direction = player.position - position
	direction = direction.normalized()
	speed = get_following_speed()
	

func action(_player_node):
	push_warning("need to implements action")
	queue_free()

func check_following():
	if player != null:
		if player.get_is_focus():
			state = states.FOLLOWING

func _on_aspiration_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body

func _on_aspiration_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and state != states.FOLLOWING:
		player = null

func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("collectArea"):
		action(area.player())
	elif area.is_in_group("destroyItem"):
		queue_free()
