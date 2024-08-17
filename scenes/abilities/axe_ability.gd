extends Ability
class_name AxeAbility

@export var cycles: float = 4
@export var distance: float = 250
@export var duration: float = 3

@onready var hitbox_component: HitboxComponent = $HitboxComponent as HitboxComponent
@onready var player: Player = get_tree().get_first_node_in_group("player") as Player


func _ready():
	AbilityTweenEffects.spiral_outward(self, player, cycles, distance, duration, true)
	AbilityTweenEffects.spin(self, cycles, duration, false)
