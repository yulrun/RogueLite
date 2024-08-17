extends Ability
class_name SineThrowAbility

@export var revolutions: float = 1.0
@export var peak_amplitude: float = 20.0
@export var distance: float = 100.0
@export var duration: float = 1.0
@export var spin: bool = true
@export var spin_speed: float = 5.0

@onready var hitbox_component: HitboxComponent = $HitboxComponent as HitboxComponent
@onready var start_position: Vector2 = get_tree().get_first_node_in_group("player").global_position
@onready var target_position: Vector2 = get_tree().get_first_node_in_group("crosshair").global_position


func _ready():
	AbilityTweenEffects.sine_over_distance(self, start_position, target_position, 
		revolutions, peak_amplitude, distance, duration, true)
		
	if spin:
		AbilityTweenEffects.spin(self, spin_speed, duration, false)

