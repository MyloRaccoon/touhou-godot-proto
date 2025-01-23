extends CharacterBody2D

signal finished

@onready var timer = $Timer

@export var spell_cards : Array[SpellCard]

var current_sp_index = 0

var direction: Vector2
var speed: float

var waiting = false

func current_sp():
	return spell_cards[current_sp_index]

func _ready() -> void:
	startup_current_sp()

func startup_current_sp():
	Spawning.create_pool("circleBoss", "enemyBullet", 500)
	current_sp().start_permanant_bullets(self)

func _physics_process(_delta: float) -> void:
	touched(1)
	print(current_sp().life)
	if current_sp().life > 0:
		if waiting:
			speed = 0
		else:
			speed = current_sp().speed
		
		if current_sp().check_spawn(position):
			current_sp().spawn_bullets(self)
			current_sp().set_next_spawn_pos()
		
		if current_sp().check_position(position):
			current_sp().set_next_pos()
			waiting = true
			timer.start(current_sp().waiting_time)

		var next_pos = current_sp().get_next_pos()
		
		direction = (next_pos - position).normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		Spawning.reset_bullets()
		await get_tree().create_timer(2).timeout
		current_sp_index += 1
		if current_sp_index >= len(spell_cards):
			print(true)
			finished.emit()
			queue_free()

func touched(dmg):
	current_sp().life -= dmg

func _on_timer_timeout() -> void:
	waiting = false
