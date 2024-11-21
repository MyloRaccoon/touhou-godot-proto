extends Node2D
class_name stage_sample

signal finished

@export var auto_start : bool = true

var enemies = {}
var current_enemie
var is_finished = false

func start():
	push_error("Stage_Sample : " + str(self) + " needs to override start() method.")

func set_enemies():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if is_ancestor_of(enemy):
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

func _ready() -> void:
	set_enemies()
	if auto_start:
		start()

func _process(_delta: float) -> void:
	if check_finished():
		is_finished = true
		finished.emit()
