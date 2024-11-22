extends Node2D
class_name stage_sample

signal finished

@export var ID : String
@export var auto_start : bool = false

var enemies = {}
var current_enemie
var is_finished = false

func start():
	push_error("Stage_Sample : " + str(self) + " needs to override start() method.")

func on_enemy_finished(id):
	enemies.erase(id)

func set_enemies():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if is_ancestor_of(enemy):
			enemy.finished.connect(on_enemy_finished.bind(enemy.ID))
			enemies[enemy.ID] = enemy
	#for child in get_children(true):
		#if child is Path2D:
			#for gr_child in child.get_children():
				#if gr_child is PathFollow2D:
					#for gr_gr_child in gr_child.get_children():
						#if gr_gr_child.is_in_group("enemy"):
							#enemies[gr_gr_child.ID] = gr_gr_child

func check_finished():
	for enemy in enemies:
		if !enemies[enemy].is_finished:
			return false
	return true

func finish():
	is_finished = true
	finished.emit()

func _ready() -> void:
	set_enemies()
	if auto_start:
		start()

func _process(_delta: float) -> void:
	if check_finished() and !is_finished:
		finish()
