extends Item

func action(player_node):
	player_node.lives += 1
	queue_free()
