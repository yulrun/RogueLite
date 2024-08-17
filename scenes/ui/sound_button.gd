extends Button
class_name SoundButton


@onready var random_stream_player_component: RandomStreamPlayerComponent = $RandomStreamPlayerComponent


func _ready() -> void:
	pressed.connect(on_button_pressed)


func on_button_pressed() -> void:
	random_stream_player_component.play_random()
