extends Resource
class_name Hero

@export var name: String = "Hero"
@export var base_health: int = 100
@export var base_speed: int = 90
@export var starting_ability: AbilityUnlock
@export var ability_list: Array[AbilityUnlock]
