@tool
extends Node2D
class_name ExperienceObject


@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var random_stream_player: RandomStreamPlayer2DComponent = $RandomStreamPlayer2DComponent


func _ready() -> void:
	$Area2D.area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D) -> void:
	Callable(disable_collision).call_deferred()
	tween_to_collect()


func disable_collision() -> void:
	collision_shape_2d.disabled = true


func tween_to_collect() -> void:
	AbilityTweenEffects.spin(self, 4.0, 0.5, false)
	
	var tween: Tween = create_tween()
	tween.set_parallel()
	tween.tween_method(lerp_to_player.bind(global_position), 0.0, 1.0, 0.25).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite_2d, "scale", Vector2.ZERO, .10).set_delay(.15)
	tween.chain()
	tween.tween_callback(collected)


func lerp_to_player(percent: float, start_position: Vector2) -> void:
	var player: Player = get_tree().get_first_node_in_group("player") as Player
	if player == null:
		return
	
	global_position = start_position.lerp(player.global_position, percent)


func collected() -> void:
	random_stream_player.play_random()
	await random_stream_player.finished
	GameEvents.emit_experience_object_collected(1)
	queue_free()


func _get_configuration_warnings() -> PackedStringArray:
	var packed_string_array: PackedStringArray = []

	if not has_node("Area2D"):
		packed_string_array.append("Area2D Node required.")

	if not has_node("Sprite2D"):
		packed_string_array.append("Sprite2D Node required.")

	return packed_string_array
