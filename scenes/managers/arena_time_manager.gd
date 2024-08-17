extends Node
class_name ArenaTimeManager


signal arena_difficulty_increased(arena_difficulty: int)

const DIFFICULTY_INTERVAL: float = 5.0

@export var end_screen_scene: PackedScene
## Time in Second(s)
@export var arena_time: int = 300

@onready var timer: Timer = $Timer

var arena_difficulty: int = 0


func _ready():
	timer.timeout.connect(on_timer_timeout)
	timer.wait_time = arena_time
	timer.start()


func _process(delta):
	var next_time_target = timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INTERVAL)
	if timer.time_left <= next_time_target:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)


func get_time_elapsed() -> float: 
	return timer.wait_time - timer.time_left


func get_time_remaining() -> float: 
	return timer.time_left


func on_timer_timeout() -> void:
	var end_screen_instance: EndScreen = end_screen_scene.instantiate() as EndScreen
	add_child(end_screen_instance)
	end_screen_instance.set_victory()
