extends StaticBody2D

signal finished

@export var auto_start : bool
@export var speed : float
@export_enum("stay", "dispawn", "loop") var finish_mod
@export var life : int
@export var nbr : int
@export var bullet : String
@export var pattern : Pattern
@export var pooling : int
@export var pattern_angle_target : NodePath
@export var custom_pos : Array[float]
@export var gain : Dictionary

@onready var spawn_pos = get_spawn_pos()
@onready var next_spawn_pos = 0
@onready var parents = get_follower_path()
@onready var follower = parents["follower"]
@onready var path = parents["path"]
@onready var sprite = get_sprite()
@onready var collision = get_collision()
var bulletPattern 
var spawnPattern
var pattern_id = "Enemy pattern: " + str(self)
var avancing : bool = false
var is_finished : bool = false

func get_follower_path():
	var parent = get_parent()
	if parent is PathFollow2D:
		var gr_parent = parent.get_parent()
		if gr_parent is Path2D:
			return {"path": gr_parent, "follower": parent}
		else: push_error("Enemy " + str(self) + " needs a Path2D grand-parent (Path2D > PathFollow2D > Enemy)")
	else: push_error("Enemy " + str(self) + " needs a PathFollow2D parent.")


func get_sprite():
	for child in get_children():
		if child is AnimatedSprite2D:
			return child
	push_error("Enemy " + str(self) + " needs a AnimatedSprite2D child.")

func get_collision():
	for child in get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			return child
	push_error("Enemy " + str(self) + " needs a CollisionShape2D or CollisionPolygon2D child.")

func set_patterns():
	pattern.bullet = bullet
	pattern.pattern_angle_target = pattern_angle_target
	Spawning.new_pattern(pattern_id, pattern)

func get_spawn_pos():
	var res = []
	if nbr != 0:
		for i in range(1, nbr+1):
			res.append(i/(nbr+1.0))
	for pos in custom_pos:
		res.append(pos)
	res.sort()
	return res

func start():
	avancing = true

func stop():
	avancing = false
	follower.progress_ratio = 0

func pause():
	avancing = false

func _ready() -> void:
	if finish_mod == 2:
		follower.loop = true
	else:
		follower.loop = false
	sprite.play()
	set_patterns()
	if pooling != 0:
		Spawning.create_pool(bullet, "enemyBullet", pooling)
	position = Vector2(0,0)
	if auto_start:
		avancing = true

func _process(_delta: float) -> void:
	if avancing:
		follower.progress_ratio += (speed/100)
		if next_spawn_pos != len(spawn_pos):
			if follower.progress_ratio >= spawn_pos[next_spawn_pos]:
				Spawning.spawn(follower, pattern_id, "enemyBullet")
				next_spawn_pos += 1
		if follower.progress_ratio >= 1:
			match finish_mod:
				1: dispawn()
				2: next_spawn_pos = 0
	if life <= 0:
		dispawn()

func dispawn():
	for key in gain:
		var value = gain[key]
		for i in range(value):
			var item = key.instantiate()
			get_tree().current_scene.instantiate_item(item, global_position)
	finished.emit()
	path.queue_free()

func touched(dmg):
	life -= dmg
