extends ColorRect

const SPEED = 50

var state: int
enum states {IN, OUT, STAY}

func fading_in():
	color.a8 = 0
	state = states.IN

func fading_out():
	color.a8 = 255
	state = states.OUT

func stay():
	state = states.STAY

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if state == states.IN:
		color.a8 += SPEED
		
		if color.a8 >= 255:
			fading_out()
			
	if state == states.OUT:
		color.a8 -= SPEED
		
		if color.a8 <= 0:
			color.a8 = 0
			stay()
 
