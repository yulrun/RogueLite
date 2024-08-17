extends Node
class_name HealthComponent


signal died
signal health_changed

@export var max_health: float = 10
## Not Required, but will prevent hit sound from not playing on death
@export var random_sound_component: RandomStreamPlayer2DComponent

var current_health: float


func _ready():
	current_health = max_health


## Used by Abilites to pass to Enemy HurtBoxContainers
## Also used by the Player to when calculating ReceivedMeleeDamage
func damage(damage_amount: float):
	current_health = max(current_health - damage_amount, 0)
	health_changed.emit()
	Callable(check_death).call_deferred()


## Used by the Player Class
## Used to then pass to a HealthBar UI
func get_health_percent():
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)


## Gets called on damage to determine if the player has died
func check_death():
	if current_health == 0:
		died.emit()
		if not random_sound_component == null:
			await random_sound_component.finished
		owner.queue_free()
