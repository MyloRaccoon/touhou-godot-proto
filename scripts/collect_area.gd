extends Area2D

func player():
	if get_parent() != null:
		if get_parent().is_in_group("player"):
			return get_parent()
