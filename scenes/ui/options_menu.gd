extends CanvasLayer
class_name OptionsMenu


signal back_pressed


@onready var sfx_slider: HSlider = %SfxSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var window_button: SoundButton = %WindowButton
@onready var back_button: SoundButton = %BackButton
@onready var panel_container: PanelContainer = %PanelContainer


func _ready() -> void:
	panel_container.pivot_offset = (panel_container.size / 2)
	tween_intro()
	back_button.pressed.connect(on_back_button_pressed)
	window_button.pressed.connect(on_windowed_button_pressed)
	sfx_slider.value_changed.connect(on_audio_slider_changed.bind("Sound Effects"))
	music_slider.value_changed.connect(on_audio_slider_changed.bind("Music"))
	update_display()


func update_display():
	var mode: DisplayServer.WindowMode = DisplayServer.window_get_mode()
	window_button.text = "Set Fullscreen" if mode == DisplayServer.WINDOW_MODE_WINDOWED else "Set Windowed"
	
	sfx_slider.value = Util.get_bus_volume_percent("Sound Effects")
	music_slider.value = Util.get_bus_volume_percent("Music")


func on_back_button_pressed() -> void:
	SaveAndLoad.save_options()
	await back_button.random_stream_player_component.finished
	back_pressed.emit()
	self.queue_free()


func on_windowed_button_pressed() -> void:
	var mode: DisplayServer.WindowMode = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	update_display()


func on_audio_slider_changed(value: float, bus_name: String) -> void:
	Util.set_bus_volume_percent(bus_name, value)
	update_display()


func tween_intro() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, .5)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
