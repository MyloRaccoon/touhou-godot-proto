extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var focus_sprite = $focus
@onready var modR = $modR
@onready var modL = $modL
@onready var homing = $homingTarget

@export var max_speed : int
@export var min_speed : int
@export_range(1.0, 4.0) var power : float
@export var score : int
@export var lives : int
var speed
var is_focus : bool

var can_shoot = true

var invisibility = false

func is_power_max() -> bool:
	return power == 4.0

func get_distance(node : Node2D):
	return sqrt((node.global_position.x - global_position.x)**2 + (node.global_position.y - global_position.y)**2)

func get_closest_enemy():
	var enemies = []
	for child in get_tree().get_nodes_in_group("enemy"):
		enemies.append(child)
	if len(enemies) == 0:
		return null
	var dist = get_distance(enemies[0])
	var enemy_res = enemies[0]
	for enemy in enemies:
		if get_distance(enemy) < dist:
			dist = get_distance(enemy)
			enemy_res = enemy
	return enemy_res

func set_pattern():
	#bug when creating pool with a sharedArea that is not the defautl one...
	Spawning.create_pool("basicBullet", "1", 100)
	Spawning.create_pool("modBullet", "1", 100)
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
	res += str(int(power))
	return res

func _ready() -> void:
	set_pattern()

func _physics_process(_delta: float) -> void:
	
	if invisibility:
		sprite.visible = !sprite.visible
		collision.disabled = true
	
	var closest_enemy = get_closest_enemy()
	if closest_enemy != null:
		homing.global_position = closest_enemy.global_position
	else:
		homing.position = Vector2(0, -58)
	
	if Input.is_action_pressed("shoot"):
		if can_shoot:
			Spawning.spawn(self, get_pattern(), "1")
			Spawning.spawn(modL, "modPattern", "1")
			Spawning.spawn(modR, "modPattern", "1")
		can_shoot = !can_shoot
	
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
		modR.position.x = 15
		modL.position.x = -15
	elif event.is_action_released("focus"):
		is_focus = false
		focus_sprite.hide()
		modR.position.x = 30
		modL.position.x = -30

func touched():
	position = Vector2(256, 448)
	lives -= 1
	power -= 1.0
	if power < 1:
		power = 1.0

func _on_timer_timeout() -> void:
	invisibility = false
	sprite.show()
	collision.disabled = false
