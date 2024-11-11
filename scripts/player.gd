extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var focus_sprite = $focus
@onready var spawnPoint = $SpawnPoint
@onready var spawnPattern = $SpawnPattern
@onready var modR = $modR
@onready var modL = $modL

@export var max_speed : int
@export var min_speed : int
var speed

func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("shoot"):
		Spawning.spawn(spawnPoint, "oneP")
		Spawning.spawn(modL, "modPattern")
		Spawning.spawn(modR, "modPattern")
	
	if Input.is_action_pressed("focus"):
		speed = min_speed
		focus_sprite.show()
		modR.position.x = 15
		modL.position.x = -15
	else:
		speed = max_speed
		focus_sprite.hide()
		modR.position.x = 30
		modL.position.x = -30
	
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
