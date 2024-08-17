extends Node
class_name EnemyManager


const MIN_SPAWN_RADIUS: int = 330
const MAX_SPAWN_RADIUS: int = 350

const time_reduction_per_minute: float = 0.10

@export var basic_enemy_scene: PackedScene
@export var ghost_enemy_scene: PackedScene
@export var arena_time_manager: ArenaTimeManager
@export var minimum_spawn_interval: float = 0.30

@onready var timer = $Timer

var base_spawn_time: float = 0
var enemy_table: WeightedTable = WeightedTable.new()


func _ready():
	enemy_table.add_item(basic_enemy_scene, 10)
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spawn_position() -> Vector2:
	var player: Node2D = get_tree().get_first_node_in_group("player") as Node2D
	
	if not player: 
		return Vector2.ZERO
	
	var spawn_position: Vector2 = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	for i in 4:
		spawn_position = player.global_position + (random_direction * randi_range(MIN_SPAWN_RADIUS, MAX_SPAWN_RADIUS))
		
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
		var result: Dictionary = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
	
		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
	
	return spawn_position


func on_timer_timeout() -> void:
	timer.start()
	
	var player: Node2D = get_tree().get_first_node_in_group("player") as Node2D
	
	if not player: 
		return
	
	# instantiate enemy and set the spawn position
	var enemy_scene: PackedScene = enemy_table.pick_item() as PackedScene
	var enemy: Node2D = enemy_scene.instantiate() as Node2D
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	
	if not entities_layer:
		get_parent().add_child(enemy)
	else:
		entities_layer.add_child(enemy)
		
	enemy.global_position = get_spawn_position()


func on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (time_reduction_per_minute / (60 / arena_time_manager.DIFFICULTY_INTERVAL)) * arena_difficulty
	time_off = min(time_off, (base_spawn_time - minimum_spawn_interval))
	timer.wait_time = base_spawn_time - time_off
	
	if arena_difficulty == 6:
		enemy_table.add_item(ghost_enemy_scene, 20)
