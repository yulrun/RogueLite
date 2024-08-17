extends CharacterBody2D
class_name Enemy


## Delay in seconds (0.0 to 5.0)
@export_range(0.0, 5.0) var attack_duration: float = 0.5
@export var damage: int = 1

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visuals: Node2D = $Visuals
@onready var movement_component: MovementComponent = $MovementComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var random_stream_component: RandomStreamPlayer2DComponent = $OnHitRandomAudioComponent

var is_attacking: bool = false


func _ready() -> void:
	hurtbox_component.hit.connect(on_hit)


func _process(delta: float) -> void:
	if not is_attacking:
		_handle_enemy_movement()


# Generic AI Movement, moves towards the player every frame
# Override this function for more specific enemy AI
func _handle_enemy_movement() -> void:
	_move_to_player()
	_adjust_sprite_direction_to_movement()
	_animate_walk_cycle()


# Basic move to Player
func _move_to_player() -> void:
	movement_component.accelerate_to_player()
	movement_component.move(self)


# Handle's flipping for direction change
func _adjust_sprite_direction_to_movement() -> void:
	var move_sign: int = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


# Handles applying animation when moving
func _animate_walk_cycle() -> void:
	if velocity != Vector2.ZERO:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")


func start_attacking() -> void:
	# Play Attack Animation
	is_attacking = true
	await get_tree().create_timer(attack_duration).timeout
	is_attacking = false


func on_hit() -> void:
	if random_stream_component == null:
		return
	random_stream_component.play_random()
