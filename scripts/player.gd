extends CharacterBody2D
class_name Player

@onready var sprite = $AnimatedSprite2D
@onready var focus_sprite = $focus
@onready var collision = $CollisionShape2D
@onready var timer = $Timer

@export var max_speed : int
@export var min_speed : int
@export_range(1.0, 4.0) var power : float = 1.0
@export var score : int
@export var lives : int
var speed = max_speed
var is_focus : bool

var invisibility = false

func get_is_focus():
	return is_focus

func set_pattern():
	push_error("need to implement set_pattern")

func get_pattern() -> String:
	var res = name + "BasicPattern"
	if is_focus:
		res += "Focus"
	res += str(int(power))
	return res

func is_power_max() -> bool:
	return power == 4.0

func _ready() -> void:
	speed = max_speed
	timer.timeout.connect(_on_timer_timeout)
	set_pattern()

func shoot():
	Spawning.spawn(self, get_pattern(), "1")

func _physics_process(_delta: float) -> void:
	
	if invisibility:
		sprite.visible = !sprite.visible
		collision.disabled = true
	born_power()
	if Input.is_action_pressed("shoot"):
		shoot()
	
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.x:
		if Input.is_action_pressed("left"):
			sprite.play("left")
		elif Input.is_action_pressed("right"):
			sprite.play("right")
	else:
		sprite.play("neutral")
	
	velocity = direction * speed

	move_and_slide()

func focus(boolean):
	is_focus = boolean
	if is_focus:
		focus_sprite.show()
		speed = min_speed
	else:
		focus_sprite.hide()
		speed = max_speed

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("focus"):
		focus(true)
	elif event.is_action_released("focus"):
		focus(false)

func born_power():
	if power < 1.0:
		power = 1.0
	elif power > 4.0:
		power = 4.0

func touched():
	invisibility = true
	Spawning.clear_all_bullets()
	position = Vector2(256, 448)
	lives -= 1
	power -= 1.0
	timer.start()

func _on_timer_timeout() -> void:
	invisibility = false
	sprite.show()
	collision.disabled = false
