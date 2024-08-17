extends AbilityController
class_name SwordAbilityController

const spawn_offset: int = 4

@export var sword_ability: PackedScene
@export var max_range: float = 100
@export var use_crosshair: bool = true

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var timer = $Timer

var additional_damage_percent: float = 1.0
var target_list: Array[Node]
var base_wait_time: float
var current_wait_time: float


func _ready() -> void:
	base_wait_time = timer.wait_time
	current_wait_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	GameEvents.unlock_added.connect(on_unlock_added)


func on_timer_timeout():
	if not player: return
	spawn_sword_instance()


func spawn_sword_instance() -> void:
	acquire_target_list()
	if target_list.is_empty(): return
	
	var sword_instance: SwordAbility = sword_ability.instantiate() as SwordAbility
	
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	
	if not foreground_layer:
		player.get_parent().add_child(sword_instance)
	else:
		foreground_layer.add_child(sword_instance)
	
	sword_instance.hitbox_component.damage = ceil(base_damage * additional_damage_percent)
	sword_instance.global_position = target_list[0].global_position
	
	# create an offset of the spawn with a radius of spawn_offset in pixels (TAU is PI*2)
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * spawn_offset
	
	# rotate towards the enemy
	var enemy_direction: Vector2 = target_list[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()


func acquire_target_list() -> void:
	target_list = get_tree().get_nodes_in_group("enemy")
	
	# Filter the list by distance
	target_list = Util.array_filter_by_distance_in_range(target_list, player.global_position, max_range)
	
	# Sort the list by distance
	target_list = Util.array_sort_by_distance_to_node2d(target_list, player.global_position)


func on_unlock_added(unlock: Unlock, current_unlocks: Dictionary):
	if not unlock is UpgradeUnlock: 
		return
		
	var ability_unlock = unlock as UpgradeUnlock
	
	match unlock.id:
		"sword_haste": 
			current_wait_time = current_wait_time - (base_wait_time * (unlock.value / 100))
			timer.wait_time = current_wait_time
			timer.start()
			var current_value: float = (1 - (current_wait_time / base_wait_time)) * 100
			GameEvents.emit_unlock_applied(unlock, current_value)
			
		"sword_damage":
			additional_damage_percent += (ability_unlock.value / 100)
			var current_value: float = (additional_damage_percent - 1) * 100
			GameEvents.emit_unlock_applied(unlock, current_value)
