extends Player

@onready var modR = $modR
@onready var modL = $modL
@onready var homingR = $homingTargetR
@onready var homingL = $homingTargetL

var can_shoot = true

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
	Spawning.create_pool("basicBullet", "playerBullet", 100)
	Spawning.create_pool("modBulletR", "playerBullet", 100)
	Spawning.create_pool("modBulletL", "playerBullet", 100)
	var p = PatternCircle.new()
	#Power 1
	p.bullet = "basicBullet"
	p.nbr = 1
	Spawning.new_pattern("ReimuBasicPattern1", p)
	Spawning.new_pattern("ReimuBasicPatternFocus1", p)
	
	#Power 2
	p = PatternCircle.new()
	p.bullet = "basicBullet"
	p.nbr = 3
	p.angle_total = 0.3
	p.angle_decal = -0.1
	Spawning.new_pattern("ReimuBasicPattern2", p)
	
	p = PatternCircle.new()
	p.bullet = "basicBullet"
	p.nbr = 3
	p.angle_total = 0.1
	p.angle_decal = -0.035
	Spawning.new_pattern("ReimuBasicPatternFocus2", p)
	
	#Power 3
	p = PatternCircle.new()
	p.bullet = "basicBullet"
	p.nbr = 5
	p.angle_total = 0.5
	p.angle_decal = -0.2
	Spawning.new_pattern("ReimuBasicPattern3", p)
	
	p = PatternCircle.new()
	p.bullet = "basicBullet"
	p.nbr = 5
	p.angle_total = 0.2
	p.angle_decal = -0.085
	Spawning.new_pattern("ReimuBasicPatternFocus3", p)
	
	#power 4
	p = PatternCircle.new()
	p.bullet = "basicBullet"
	p.nbr = 8
	p.angle_total = 1
	p.angle_decal = -0.45
	Spawning.new_pattern("ReimuBasicPattern4", p)
	
	p = PatternCircle.new()
	p.bullet = "basicBullet"
	p.nbr = 8
	p.angle_total = 0.3
	p.angle_decal = -0.13
	Spawning.new_pattern("ReimuBasicPatternFocus4", p)

func shoot():
	if can_shoot:
		Spawning.spawn(self, get_pattern(), "playerBullet")
		Spawning.spawn(modL, "modPatternL", "playerBullet")
		Spawning.spawn(modR, "modPatternR", "playerBullet")
	can_shoot = !can_shoot

func _physics_process(delta: float) -> void:
	var closest_enemy = get_closest_enemy()
	if closest_enemy != null:
		homingR.global_position = closest_enemy.global_position
		homingL.global_position = closest_enemy.global_position
	else:
		homingR.position = Vector2(modR.position.x, -50)
		homingL.position = Vector2(modL.position.x, -50)
	super._physics_process(delta)

func focus(boolean):
	is_focus = boolean
	if is_focus:
		focus_sprite.show()
		speed = min_speed
		modL.position.x = 15
		modR.position.x = -15
	else:
		focus_sprite.hide()
		speed = max_speed
		modL.position.x = 30
		modR.position.x = -30
