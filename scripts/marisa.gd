extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var focus_sprite = $focus

@export var max_speed : int
@export var min_speed : int
@export var power : int
@export var score : int
@export var lives : int
var speed
var is_focus : bool

var can_shoot = true

func set_pattern():
	return
	Spawning.create_pool("basicBullet", "0", 100)
	Spawning.create_pool("modBullet", "0", 100)
	var p = PatternCircle.new()
	#Power 1
	p.bullet = "basicBullet"
	p.nbr = 1
	Spawning.new_pattern("basicPattern1", p)
	Spawning.new_pattern("basicPatternFocus1", p)
	
	#Power 2
	p = PatternCircle.new()
	p.bullet = "basicBullet"
	p.nbr = 3
	p.angle_total = 0.3
	p.angle_decal = -0.1
	Spawning.new_pattern("basicPattern2", p)
	
	p = PatternCircle.new()
	p.bullet = "basicBullet"
	p.nbr = 3
	p.angle_total = 0.1
	p.angle_decal = -0.035
	Spawning.new_pattern("basicPatternFocus2", p)
	
	#Power 3
	p = PatternCircle.new()
	p.bullet = "basicBullet"
	p.nbr = 5
	p.angle_total = 0.5
	p.angle_decal = -0.2
	Spawning.new_pattern("basicPattern3", p)
	
	p = PatternCircle.new()
	p.bullet = "basicBullet"
	p.nbr = 5
	p.angle_total = 0.2
	p.angle_decal = -0.085
	Spawning.new_pattern("basicPatternFocus3", p)
	
	#power 4
	p = PatternCircle.new()
	p.bullet = "basicBullet"
	p.nbr = 8
	p.angle_total = 1
	p.angle_decal = -0.45
	Spawning.new_pattern("basicPattern4", p)
	
	p = PatternCircle.new()
	p.bullet = "basicBullet"
	p.nbr = 8
	p.angle_total = 0.3
	p.angle_decal = -0.13
	Spawning.new_pattern("basicPatternFocus4", p)

func get_pattern() -> String:
	var res = "basicPattern"
	if is_focus:
		res += "Focus"
	res += str(power)
	return "basicMarisa"
	return res

func _ready() -> void:
	set_pattern()

func _physics_process(_delta: float) -> void:
	
	if Input.is_action_pressed("shoot"):
		Spawning.spawn($Marker2D, get_pattern())
	
	if Input.is_action_pressed("focus"):
		speed = min_speed
	else:
		speed = max_speed
	
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

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("focus"):
		is_focus = true
		focus_sprite.show()
	elif event.is_action_released("focus"):
		is_focus = false
		focus_sprite.hide()
