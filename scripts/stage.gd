extends Node2D
class_name stage

signal finished
var is_finished

@export var auto_start : bool = false

var samples = {}

func start():
	push_error("Stage " + str(self) + " needs to implements start()")

func set_samples():
	for sample in get_tree().get_nodes_in_group("stage_sample"):
		if is_ancestor_of(sample):
			samples[sample.ID] = sample

func _ready() -> void:
	set_samples()
	if auto_start:
		start()

func check_finished():
	if !is_finished:
		for sample in samples:
			if !samples[sample].is_finished:
				return false
	return true

func finish():
	is_finished = true
	finished.emit()

func _process(_delta: float) -> void:
	if check_finished():
		finish()
