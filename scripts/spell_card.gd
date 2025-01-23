@tool
extends PackedDataContainer
class_name SpellCard

@export var life : int

@export_group("movement")
@export var positions : Array[Vector2]
@export var loop : bool = true
@export var waiting_time : float = 1.0
@export var speed : float

@export_group("bullet and pattern")
@export var unique_patterns : Array[String]
@export var permanant_patterns : Array[String]
@export var spawn_positions : Array[Vector2]

var next_spawn_pos = 0
var next_position = 0

func start_permanant_bullets(spawner):
	for pattern in permanant_patterns:
		Spawning.spawn(spawner, pattern, "enemyBullet")

func spawn_bullets(spawner):
	for pattern in unique_patterns:
		Spawning.spawn(spawner, pattern, "enemyBullet")

func check_spawn(position: Vector2):
	if position.distance_to(get_next_spawn_pos()) <= 10:
		return true
	return false

func set_next_spawn_pos():
	next_spawn_pos += 1
	clamp_next_spawn_pos()

func check_position(position: Vector2):
	if position.distance_to(get_next_pos()) <= 10:
		return true
	return false

func set_next_pos():
	next_position += 1
	clamp_next_pos()

func clamp_next_pos():
	if next_position >= len(positions):
		if loop:
			next_position = 0
		else:
			next_position = len(positions) -1 

func clamp_next_spawn_pos():
	if next_spawn_pos >= len(spawn_positions):
		if loop:
			next_spawn_pos = 0
		else:
			next_spawn_pos = len(spawn_positions) -1 

func get_next_pos():
	return positions[next_position]

func get_next_spawn_pos():
	return spawn_positions[next_spawn_pos]
