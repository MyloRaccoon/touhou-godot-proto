extends StaticBody2D

signal finished

@export var ID : String
@export var auto_start : bool
@export var speed : float
@export_enum("stay", "dispawn", "loop") var finish_mod
@export var life : int
@export var nbr : int
@export var bullet : String
@export var pattern : Pattern
@export var pooling : int
@export var custom_pos : Array[float]
@export var custom_spawn_point : Node2D
@export var gain : Dictionary

@onready var spawn_pos = get_spawn_pos()
@onready var next_spawn_pos = 0
@onready var parents = get_follower_path()
@onready var follower = parents["follower"]
@onready var path = parents["path"]

var sprite
var collision
var visible_notifier

var started : bool
var bulletPattern 
var spawnPattern
var pattern_id = "Enemy pattern: " + str(self) + Global.get_id()
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


func get_sprite_collision_visible():
	for child in get_children():
		if child is AnimatedSprite2D:
			sprite = child
		elif child is CollisionShape2D or child is CollisionPolygon2D:
			collision = child
		elif child is VisibleOnScreenNotifier2D:
			visible_notifier = child
	if sprite == null:
		push_error("Enemy " + str(self) + " needs a AnimatedSprite2D child.")
	if collision == null:
		push_error("Enemy " + str(self) + " needs a CollisionShape2D or CollisionPolygon2D child.")
	if visible_notifier == null:
		push_error("Enemy " + str(self) + "needs a VisibleOnScreenNotifier2D child.")

func set_collision():
	if visible_notifier.is_on_screen() and started:
		collision.disabled = false
	else:
		collision.disabled = true
	
func set_patterns():
	pattern.bullet = bullet
	Spawning.new_pattern(pattern_id, pattern)
	if custom_spawn_point != null:
		custom_spawn_point.auto_pattern_id = pattern_id
		custom_spawn_point.shared_area_name = "enemyBullet"

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
	started = true
	avancing = true

func stop():
	started = false
	avancing = false
	follower.progress_ratio = 0
	next_spawn_pos = 0

func pause():
	avancing = false

func replay():
	stop()
	start()

func _ready() -> void:
	get_sprite_collision_visible()
	follower.loop = false
	sprite.play()
	set_patterns()
	if pooling != 0:
		Spawning.create_pool(bullet, "enemyBullet", pooling)
		if custom_spawn_point != null:
			custom_spawn_point.pool_amount = pooling
	position = Vector2(0,0)
	if auto_start:
		start()

func _process(_delta: float) -> void:
	set_collision()
	if avancing:
		follower.progress_ratio += (speed/100)
		if next_spawn_pos != len(spawn_pos):
			if follower.progress_ratio >= spawn_pos[next_spawn_pos]:
				if custom_spawn_point != null:
					Spawning.spawn(custom_spawn_point, pattern_id, "enemyBullet")
				else:
					Spawning.spawn(follower, pattern_id, "enemyBullet")
				next_spawn_pos += 1
		if follower.progress_ratio >= 1:
			match finish_mod:
				1: dispawn()
				2: replay()
	if life <= 0:
		spawn_gains()
		dispawn()

func spawn_gains():
	for key in gain:
		var value = gain[key]
		for i in range(value):
			var item = key.instantiate()
			get_tree().current_scene.instantiate_item(item, global_position)

func dispawn():
	finished.emit()
	avancing = false
	follower.queue_free()

func touched(dmg):
	life -= dmg
