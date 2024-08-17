extends Node
class_name AbilityController


@export var unlock_list: Array[UpgradeUnlock]

var base_damage: float = 1.0
var base_crit_rate: float = 1.0
var base_crit_damage: float = 1.1


func set_base_damage(damage: float) -> void:
	base_damage = damage


func set_base_crit_rate(crit_rate: float) -> void:
	base_crit_rate = crit_rate


func set_base_crit_damage(crit_damage: float) -> void:
	base_crit_damage = crit_damage
