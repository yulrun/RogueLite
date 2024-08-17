extends CanvasLayer
class_name MainMenu


signal outro_finished

@onready var play_button: SoundButton = %PlayButton
@onready var options_button: SoundButton = %OptionsButton
@onready var quit_button: SoundButton = %QuitButton
@onready var margin_container: MarginContainer = $MarginContainer
@onready var panel_container: PanelContainer = $MarginContainer/PanelContainer

var options_scene: PackedScene = preload("res://scenes/ui/options_menu.tscn")


func _ready() -> void:
	panel_container.pivot_offset = (panel_container.size / 2)
	play_button.pressed.connect(on_play_pressed)
	options_button.pressed.connect(on_options_pressed)
	quit_button.pressed.connect(on_quit_pressed)
	tween_intro()


func on_play_pressed() -> void:
	tween_outro()
	await outro_finished
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_options_pressed() -> void:
	margin_container.visible = false
	var options_instance: OptionsMenu = options_scene.instantiate() as OptionsMenu
	add_sibling(options_instance)
	options_instance.back_pressed.connect(on_options_closed)


func on_options_closed() -> void:
	tween_intro()
	margin_container.visible = true


func on_quit_pressed() -> void:
	await quit_button.random_stream_player_component.finished
	get_tree().quit()


func tween_intro() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .5)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func tween_outro() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, .3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	await tween.finished
	margin_container.visible = false
	outro_finished.emit()
