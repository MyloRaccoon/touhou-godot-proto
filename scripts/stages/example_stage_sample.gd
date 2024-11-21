extends stage_sample

func start():
	is_finished = false
	enemies["bf1"].start()
	await get_tree().create_timer(1).timeout
	enemies["bf2"].start()
	await get_tree().create_timer(1).timeout
	enemies["bf3"].start()
