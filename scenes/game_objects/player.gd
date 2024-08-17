extends CharacterBody2D
class_name Player


@export var hero_class: Hero
@export var group_damage_numbers: bool = true

@onready var abilities_component: AbilitiesComponent = $AbilitiesComponent as AbilitiesComponent
@onready var health_component: HealthComponent = $HealthComponent as HealthComponent
@onready var melee_collision_area: Area2D = $MeleeCollisionArea as Area2D
@onready var health_bar: ProgressBar = $HealthBar as ProgressBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visuals: Node2D = $Visuals
@onready var movement_component: MovementComponent = $MovementComponent
@onready var enemy_collision_shape: CollisionShape2D = $HurtboxComponent/CollisionShape2D
@onready var on_hit_audio_component: RandomStreamPlayer2DComponent = $OnHitRandomAudioComponent

var enemies_in_melee_range: Array[Enemy]
var base_speed: int = 0

## Setup the hero based on the Hero Class
func _initialize_hero() -> void:
	# Initialize starting ability, and unlockable abilities
	var unlock_manager: UnlockManager = get_tree().get_first_node_in_group("unlock_manager") as UnlockManager
	unlock_manager.apply_unlock(hero_class.starting_ability)
	unlock_manager.mass_add_to_unlock_pool(hero_class.ability_list)
	
	# Initialize player health
	var hero_base_health: int = hero_class.base_health
	health_component.max_health = hero_base_health
	
	# Initialize movement speed
	var hero_base_speed: int = hero_class.base_speed
	movement_component.max_speed = hero_base_speed
	base_speed = hero_base_speed


func _ready():
	melee_collision_area.body_entered.connect(_on_body_entered)
	melee_collision_area.body_exited.connect(_on_body_exited)
	health_component.health_changed.connect(_on_health_changed)
	GameEvents.unlock_added.connect(_on_unlock_added)
	_initialize_hero()
	_update_health_display()


func _process(delta) -> void:
	var movement_direction: Vector2 = _get_movement_direction()
	
	movement_component.accelerate_in_direction(movement_direction)
	
	movement_component.move(self)
	
	# Handles applying animation when moving
	if movement_direction != Vector2.ZERO:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
	
	# Handle's flipping for direction change
	var move_sign: int = sign(movement_direction.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)
	
	_calculate_received_melee_damage()


## Player input, used in Process
func _get_movement_direction() -> Vector2: 
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")


## Used in _process, based on enemies being added/removed with: 
## _on_body_entered and _on_body_exited signals
func _calculate_received_melee_damage():
	if enemies_in_melee_range.is_empty():
		return
	
	var total_damage: int = 0
	
	for enemy in enemies_in_melee_range:
		if not enemy.is_attacking:
			enemy.start_attacking()
			var damage: int = enemy.damage
			total_damage += damage
			if not group_damage_numbers:
				_inflict_melee_damage(damage)
	
	if group_damage_numbers and total_damage > 0:
		_inflict_melee_damage(total_damage)


## Used in _calculate_received_melee_damage only
func _inflict_melee_damage(damage: int):
	health_component.damage(damage)
	on_hit_audio_component.play_random()
	Util.instantiate_floating_text(self, damage, FloatingText.text_type.PLAYER_DAMAGE)
	


## used in _on_unlock_added when the unlock is an Ability
func _instantiate_new_ability(ability: AbilityUnlock) -> void:
	var controller: AbilityController = ability.ability_controller_scene.instantiate() as AbilityController
	
	# initialize damage variables
	controller.set_base_damage(ability.base_damage)
	controller.set_base_crit_rate(ability.base_crit_rate)
	controller.set_base_crit_damage(ability.base_crit_damage)
	
	abilities_component.add_child(controller)


## used in _on_unlock_added when the upgrade is player related
func _apply_player_upgrades(id: String, current_unlocks: Dictionary) -> void:
	match id:
		"player_speed": 
			var speed_increase: int = base_speed * (current_unlocks["player_speed"]["current_value"]/100)
			movement_component.max_speed = base_speed + speed_increase


## Used in _on_health_changed
func _update_health_display():
	health_bar.value = health_component.get_health_percent()


## Comes from MeleeCollisionArea, local event
func _on_body_entered(body: Node2D) -> void:
	var enemy: Enemy = (body as Enemy)
	enemies_in_melee_range.append(enemy)


## Comes from MeleeCollisionArea, local event
func _on_body_exited(body: Node2D) -> void:
	var enemy: Enemy = (body as Enemy)
	enemies_in_melee_range = enemies_in_melee_range.filter(func(e): return e != enemy)


## Comes from Health Component, local event
func _on_health_changed() -> void:
	GameEvents.emit_player_damaged()
	_update_health_display()


## Relayed through GameEvents by UnlockManager when a new unlock gets added
## Player listens to it to apply new Abilities and Player based Upgrades
## AbilityControllers listen to it to apply Ability Specific Upgrades
func _on_unlock_added(unlock: Unlock, current_unlocks: Dictionary) -> void:
	if unlock is AbilityUnlock:
		_instantiate_new_ability((unlock as AbilityUnlock))
	elif unlock.id.begins_with("player"):
		_apply_player_upgrades(unlock.id, current_unlocks)
