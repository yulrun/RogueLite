## Class mainly used for Enemies, to take damage when ability hit boxes enter the area
extends Area2D
class_name HurtboxComponent


signal hit

@export var health_component: HealthComponent


func _ready() -> void:
	area_entered.connect(on_area_entered)


func take_damage(hitbox_component: HitboxComponent) -> void:
	hit.emit()
	var damage: float = hitbox_component.damage
	health_component.damage(damage)
	Util.instantiate_floating_text(self, damage, FloatingText.text_type.DAMAGE)


func on_area_entered(other_area: Area2D) -> void:
	if not other_area is HitboxComponent: 
		return
	
	if health_component == null:
		return
	
	take_damage(other_area as HitboxComponent)
