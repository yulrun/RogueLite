extends Camera2D
class_name GameCamera

var target_position: Vector2 = Vector2.ZERO
#var camera_position: Vector2
#var overshoot: Vector2 = Vector2(1.5, 1.5)


func _ready() -> void:
	make_current()


func _process(delta) -> void:
	acquire_target()
	global_position = global_position.lerp(target_position, (15 * delta))
	if global_position.distance_to(target_position) <= 5:
		position = position.round()
#	camera_position = lerp_overshoot_v(position, target_position, 0.2, overshoot)
#	position = camera_position
		

func acquire_target() -> void:
	var player_nodes: Array[Node] = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		var player: Node2D = player_nodes[0] as Node2D
		target_position = player.global_position
 
#func lerp_overshoot(origin: float, target: float, weight: float, overshoot: float) -> float:
#	var distance: float = target - origin * weight
#
#	if is_equal_approx(distance, 0.0):
#		return target;
#
#	var distanceSign := signf(distance)
#	var lerpValue: float = lerp(origin, target + (overshoot * distanceSign), weight)
#
#	if distanceSign == 1.0:
#			lerpValue = min(lerpValue, target)
#	elif distanceSign == -1.0:
#			lerpValue = max(lerpValue, target)
#
#	return lerpValue
#
#func lerp_overshoot_v(from: Vector2, to: Vector2, weight: float, overshoot: Vector2) -> Vector2:
#	var x = lerp_overshoot(from.x, to.x, weight, overshoot.x)
#	var y = lerp_overshoot(from.y, to.y, weight, overshoot.y)
#	return Vector2(x, y)
