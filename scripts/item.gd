extends CharacterBody2D
class_name Item

@export var from_ceilling : bool

const SPAWNING_SPD = 500
const FALLING_SPD = 150

var speed
var direction : Vector2

var frame = 0
var frame_change = 20
var changed = false

var following = false

var player

func get_following_speed():
	if player != null:
		return player.max_speed + 100
	return 800

func _ready() -> void:
	if from_ceilling:
		position = Vector2(256, -54)
		frame_change = 0
	else:
		set_base_dir()

func _physics_process(_delta: float) -> void:
	if !following:
		check_following()
		frame += 1
	if frame >= frame_change and !changed and !following:
		set_gravity_dir()
		changed = true
	
	if following:
		set_dir_to_player()

	velocity = speed * direction

	move_and_slide()

func set_base_dir():
	speed = SPAWNING_SPD
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 0)).normalized()

func set_gravity_dir():
	speed = FALLING_SPD
	direction = Vector2(0, 1).normalized()

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
			following = true

func _on_aspiration_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body

func _on_aspiration_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and !following:
		player = null

func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("collectArea"):
		action(area.player())
	elif area.is_in_group("destroyItem"):
		queue_free()
