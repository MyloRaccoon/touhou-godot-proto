extends Item

func action(player_node):
	player_node.score += 100
	queue_free()
