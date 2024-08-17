extends Node2D
class_name FloatingText


@onready var label: Label = $%Label

@export var damage_color: Color
@export var player_damage_color: Color
@export var critical_color: Color
@export var experience_color: Color
@export var font_size: int = 16

enum text_type {
	DAMAGE,
	PLAYER_DAMAGE,
	CRITICAL,
	EXPERIENCE
}


func start(text: String, type: text_type = text_type.DAMAGE) -> void:
	label.set("theme_override_font_sizes/font_size", font_size)
	
	match type:
		text_type.DAMAGE:
			damage(text)
		text_type.PLAYER_DAMAGE:
			player_damage(text)
		text_type.CRITICAL:
			critical(text)
		text_type.EXPERIENCE:
			experience(text)


func damage(text: String) -> void:
	label.text = text
	label.set("theme_override_colors/font_color", damage_color)
	floating_text_tween_normal()


func critical(text: String) -> void:
	label.text = "Critical!\n" + text
	label.set("theme_override_colors/font_color", critical_color)
	floating_text_tween_slam()


func experience(text: String) -> void:
	label.text = text
	label.set("theme_override_colors/font_color", experience_color)
	floating_text_tween_slam()


func player_damage(text: String) -> void:
	label.text = "-" + text
	label.set("theme_override_colors/font_color", player_damage_color)
	floating_text_tween_normal()


func floating_text_tween_normal() -> void:
	var tween: Tween = create_tween()
	
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 16), .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 48), .4)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(self, "scale", Vector2.ZERO, .15).set_delay(.1)
	tween.chain()
	
	tween.tween_callback(queue_free)


func floating_text_tween_slam() -> void:
	var tween: Tween = create_tween()
	
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 16), .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2.ONE * 2.25, .10)
	tween.tween_property(self, "scale", Vector2.ONE, 0.10).set_delay(.2)
	tween.set_parallel(false)
	
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 48), .4)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(self, "scale", Vector2.ZERO, .15).set_delay(.1)
	tween.chain()
	
	tween.tween_callback(queue_free)
