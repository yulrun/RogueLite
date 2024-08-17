extends Node
class_name MovementComponent


@export var max_speed: int = 40
@export var acceleration: float = 5.0

var velocity = Vector2.ZERO

## Triggers the Owner to move based on current velocity/direction
func move(character_body: CharacterBody2D):
	character_body.velocity = velocity
	character_body.move_and_slide()
	velocity = character_body.velocity


## Sets up the desired direction and velocity
func accelerate_in_direction(direction: Vector2):
	var desired_velocity: Vector2 = direction * max_speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))

## Self explanitory
func decelerate():
	accelerate_in_direction(Vector2.ZERO)

## An all-in-one function for a simple more to player script
func accelerate_to_player():
	var owner_node2d: Node2D = owner as Node2D
	if owner_node2d == null:
		return
	
	var player: Player = get_tree().get_first_node_in_group("player") as Player
	if player == null:
		return
	
	var direction: Vector2 = (player.global_position - owner_node2d.global_position).normalized()
	accelerate_in_direction(direction)
