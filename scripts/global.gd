extends Node

var last_id = 0

func get_id():
	last_id += 1
	return str(last_id)
