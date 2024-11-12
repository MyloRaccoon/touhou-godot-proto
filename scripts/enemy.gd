extends CharacterBody2D

@export var auto_start : bool
@export var speed : float
@export var nbr : int
@export var pattern : Pattern
@export var pooling : int
@export var custom_pos : Array[float]

@onready var spawn_pos = get_spawn_pos()
@onready var next_spawn_pos = 0
@onready var follower = get_follower()
var bulletPattern 
var spawnPattern
var pattern_id = "Enemy pattern: " + str(self)
var avancing : bool = false

func get_follower():
	if get_parent() is PathFollow2D:
		return get_parent()
	push_error("Enemy " + str(self) + " needs to have a PathFollow2D as a parent.")

func set_patterns():
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
	set_patterns()
	#if pooling != 0:
		#Spawning.create_pool(pattern_id, "0", pooling)
	position = Vector2(0,0)
	if auto_start:
		avancing = true

func _process(_delta: float) -> void:
	if avancing:
		follower.progress_ratio += (speed/100)
		if next_spawn_pos != len(spawn_pos):
			if follower.progress_ratio >= spawn_pos[next_spawn_pos]:
				Spawning.spawn(self, pattern_id)
				next_spawn_pos += 1
