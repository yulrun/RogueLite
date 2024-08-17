extends Node2D
class_name DeathAnimationComponent


@export var health_component: HealthComponent
@export var sprite: Sprite2D

func _ready():
	$GPUParticles2D.texture = sprite.texture
	health_component.died.connect(on_died)


func on_died():
	if owner == null or not owner is Node2D:
		return
		
	var spawn_position: Vector2 = owner.global_position
	
	var entites: Node = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self)
	entites.add_child(self)
	
	global_position = spawn_position
	$AnimationPlayer.play("default")
