extends CanvasLayer

@export var arena_time_manager: ArenaTimeManager
@onready var label: Label = $%Label

func _process(delta):
	if not arena_time_manager: return
	var time_remaining: float = arena_time_manager.get_time_remaining()
	label.text = format_seconds_to_string(time_remaining)


func format_seconds_to_string(seconds: float):
	var minutes: float = floor(seconds / 60)
	var remaining_seconds: float = floor(seconds - (minutes * 60))
	return str(minutes) + ":" + ("%02d" % remaining_seconds)
