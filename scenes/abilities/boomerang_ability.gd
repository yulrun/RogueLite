extends Ability
class_name BoomerangAbility

@export var distance: float = 125
@export var duration: float = 1.25
@export var scale_variable: float = 2
@export var use_crosshair: bool = true

@onready var hitbox_component: HitboxComponent = $HitboxComponent as HitboxComponent
@onready var player_location: Vector2 = get_tree().get_first_node_in_group("player").global_position
@onready var crosshair: Vector2 = get_tree().get_first_node_in_group("crosshair").global_position
@onready var player: Player = get_tree().get_first_node_in_group("player") as Player


func _ready():
	AbilityTweenEffects.spin(self, 1, duration, false)
	AbilityTweenEffects.grow_and_shrink(self, 1.5, duration, false)
	AbilityTweenEffects.boomerang(self, player, crosshair, distance, duration, true)
