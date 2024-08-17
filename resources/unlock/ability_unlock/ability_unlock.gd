extends Unlock
class_name AbilityUnlock

@export var ability_controller_scene: PackedScene
@export_range(1, 1000) var base_damage: float
@export_range(1.0, 2.0) var base_crit_rate: float
@export_range(1.0, 2.0) var base_crit_damage: float
