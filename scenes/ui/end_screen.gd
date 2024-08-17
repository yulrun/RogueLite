extends CanvasLayer
class_name EndScreen

@onready var restart_button: SoundButton = %RestartButton as Button
@onready var quit_button: SoundButton = %QuitButton as Button
@onready var title_label: Label = %TitleLabel as Label
@onready var description_label: Label = %DescriptionLabel as Label
@onready var panel_container: PanelContainer = %PanelContainer
@onready var victory_stream_player: AudioStreamPlayer = $VictoryStreamPlayer
@onready var defeat_stream_player: AudioStreamPlayer = $DefeatStreamPlayer


func _ready():
	panel_container.pivot_offset = panel_container.size / 2
	var tween: Tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	get_tree().paused = true
	restart_button.pressed.connect(on_restart_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)


func play_jingle(defeat: bool = false) -> void:
	if defeat:
		defeat_stream_player.play()
	else:
		victory_stream_player.play()


func set_defeat():
	play_jingle(true)
	title_label.text = "Failed!"
	description_label.text = "You Died..."


func set_victory():
	play_jingle(false)
	title_label.text = "Victory!"
	description_label.text = "You Survived!"


func on_restart_button_pressed() -> void:
	await quit_button.random_stream_player_component.finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_quit_button_pressed() -> void:
	await quit_button.random_stream_player_component.finished
	get_tree().quit()
