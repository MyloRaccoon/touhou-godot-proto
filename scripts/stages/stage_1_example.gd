extends stage

func check_finished():
	return samples["twoCircle"].is_finished

func start():
	samples["threeF"].start()
	await samples["threeF"].finished
	samples["twoCircle"].start()
