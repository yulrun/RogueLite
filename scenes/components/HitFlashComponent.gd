extends Node
class_name HitFlashComponent


signal finished

@export var health_component: HealthComponent
@export var sprite: Sprite2D
@export var hit_flash_material: ShaderMaterial

var hit_flash_tween: Tween
var sprite_shader_material: ShaderMaterial


func _ready() -> void:
	health_component.health_changed.connect(on_health_changed)
	sprite.material = hit_flash_material
	sprite_shader_material = sprite.material as ShaderMaterial

## Causes sprite to flash white when health changes on target
## Its callback singal of 'finished' not general used, but available
func on_health_changed():
	if hit_flash_tween != null && hit_flash_tween.is_valid():
		hit_flash_tween.kill()
	
	sprite_shader_material.set_shader_parameter("lerp_percent", 1.0)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(sprite_shader_material, "shader_parameter/lerp_percent", 0.0, .3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	await hit_flash_tween.finished
	finished.emit()
