extends Node
class_name TestAbilityController

@export var test_ability_scene: PackedScene
@onready var timer: Timer = $Timer as Timer

var player: Player
var foreground: Node2D
var damage: float = 10


func _ready():
	if not test_ability_scene: return
	timer.timeout.connect(on_timer_timeout)
	player = get_tree().get_first_node_in_group("player") as Player
	foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D


func on_timer_timeout():
	if not player or not foreground: return
	
	var axe_instance: Node2D = test_ability_scene.instantiate() as Node2D
	foreground.add_child(axe_instance)
	axe_instance.global_position = player.global_position
	axe_instance.hitbox_component.damage = damage
