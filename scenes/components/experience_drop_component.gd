extends Node
class_name ExperienceDropComponent


@export_range(0, 1) var drop_percent: float = 0.7
@export var health_component: HealthComponent

@export var exp_object: PackedScene


func _ready():
	(health_component as HealthComponent).died.connect(on_died)


func on_died():
	if randf() > drop_percent:
		return
	
	if not exp_object:
		return
	
	if not owner is Node2D:
		return
		
	var spawn_position = (owner as Node2D).global_position
	var exp_object_instance = exp_object.instantiate() as Node2D
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	
	if not entities_layer:
		owner.get_parent().add_child(exp_object_instance)
	else:
		entities_layer.add_child(exp_object_instance)

	exp_object_instance.global_position = spawn_position
