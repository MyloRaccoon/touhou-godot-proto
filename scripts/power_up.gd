extends Item

func action(player_node):
	player_node.power += 0.01
	queue_free()
