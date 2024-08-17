extends AbilityController
class_name AxeAbilityController

@export var axe_ability_scene: PackedScene
@onready var timer: Timer = $Timer as Timer

var player: Player
var foreground: Node2D
var additional_damage_percent: float = 1.0


func _ready():
	timer.timeout.connect(on_timer_timeout)
	player = get_tree().get_first_node_in_group("player") as Player
	foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	GameEvents.unlock_added.connect(on_unlock_added)


func on_timer_timeout():
	if not player or not foreground: return
	
	var axe_instance: Node2D = axe_ability_scene.instantiate() as Node2D
	foreground.add_child(axe_instance)
	axe_instance.global_position = player.global_position
	axe_instance.hitbox_component.damage = ceil(base_damage * additional_damage_percent)


func on_unlock_added(unlock: Unlock, current_unlocks: Dictionary):
	if not unlock is UpgradeUnlock: 
		return
		
	var ability_unlock = unlock as UpgradeUnlock
	
	match unlock.id:
		"axe_damage":
			additional_damage_percent += (ability_unlock.value / 100)
			var current_value: float = (additional_damage_percent - 1) * 100
			GameEvents.emit_unlock_applied(unlock, current_value)
