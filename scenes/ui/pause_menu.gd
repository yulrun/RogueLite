extends CanvasLayer
class_name PauseMenu


signal outro_finished

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var resume_button: SoundButton = %ResumeButton
@onready var options_button: SoundButton = %OptionsButton
@onready var quit_button: SoundButton = %QuitButton
@onready var margin_container: MarginContainer = $MarginContainer
@onready var panel_container: PanelContainer = $MarginContainer/PanelContainer

var options_scene: PackedScene = preload("res://scenes/ui/options_menu.tscn")
var is_resuming: bool = false

func _ready() -> void:
	panel_container.pivot_offset = (panel_container.size / 2)
	get_tree().paused = true
	resume_button.pressed.connect(on_button_pressed.bind(resume_button))
	options_button.pressed.connect(on_button_pressed.bind(options_button))
	quit_button.pressed.connect(on_button_pressed.bind(quit_button))
	tween_intro()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().root.set_input_as_handled()
		resume_gameplay()


func on_button_pressed(button: SoundButton) -> void:
	match button:
		resume_button:
			resume_gameplay()
		options_button:
			margin_container.visible = false
			var options_instance: OptionsMenu = options_scene.instantiate() as OptionsMenu
			add_sibling(options_instance)
			options_instance.back_pressed.connect(on_options_closed)
		quit_button:
			tween_outro()
			await outro_finished
			ScreenTransition.transition()
			await ScreenTransition.transitioned_halfway
			get_tree().paused = false
			get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func on_options_closed() -> void:
	tween_intro()
	margin_container.visible = true


func fade_out_scene() -> void:
	animation_player.play("fade_out")
	await animation_player.animation_finished


func tween_intro() -> void:
	panel_container.scale = Vector2.ZERO
	margin_container.visible = true
	var tween: Tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func tween_outro() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, .3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	await tween.finished
	margin_container.visible = false
	outro_finished.emit()


func resume_gameplay() -> void:
	if is_resuming:
		return
	
	is_resuming = true
	tween_outro()
	await outro_finished
	fade_out_scene()
	get_tree().paused = false
	self.queue_free()
