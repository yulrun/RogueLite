extends Node

@export var floating_text_scene: PackedScene


# filters nodes by range, squared to is more performant, but requires max_range to be squared as well
# removes all nodes from the array that are further than max_range
func array_filter_by_distance_in_range(array: Array[Node], target: Vector2, max_range: float) -> Array[Node]:
	return array.filter(func(element: Node2D):
		return element.global_position.distance_squared_to(target) < pow(max_range, 2)
	)


# sorts by comparing element a to b
# sorts nodes by distance from target
func array_sort_by_distance_to_node2d(array: Array[Node], target: Vector2) -> Array[Node]:
	if array.is_empty(): return array
	else:
		array.sort_custom(func(a: Node2D, b: Node2D):
			var a_distance = a.global_position.distance_squared_to(target)
			var b_distance = b.global_position.distance_squared_to(target)
			return a_distance < b_distance
		)
		return array


func set_bus_volume_percent(bus_name: String, percent: float) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	var volume_db: float = linear_to_db(percent)
	AudioServer.set_bus_volume_db(bus_index, volume_db)


func get_bus_volume_percent(bus_name: String) -> float:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	var volume_db: float = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)


func instantiate_floating_text(user: Node2D, value, type: FloatingText.text_type = FloatingText.text_type.DAMAGE) -> void:
	var floating_text: FloatingText = floating_text_scene.instantiate() as FloatingText
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	floating_text.global_position = user.global_position + (Vector2.UP * 16)
	floating_text.start(str(value), type)


func get_player() -> Player:
	return get_tree().get_first_node_in_group("player")
