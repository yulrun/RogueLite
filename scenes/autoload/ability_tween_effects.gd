extends Node
## AbilityTweenEffects
##
## @author YulRun - Matt Janes - 2023


## Spins the object and qeue_free's the object at the end of the tween
## object: should always be self
## revolutions: the amount of full spins you want it to complete
## duration: how long you want it to complete all revolutions
func spin(object: Node2D, revolutions: float, duration: float, queue_free_callback: bool) -> void:
	var tween: Tween = object.create_tween() as Tween
	
	# these value's shouldn't change for proper boomerang effect.
	var start_length: float = 0.0
	
	tween.tween_method(func(value: float):
		object.global_rotation = (TAU * value)
		, start_length, revolutions, duration)
	
	if queue_free_callback:
		tween.tween_callback(object.queue_free)


func grow_and_shrink(object: Node2D, target_size: float, duration: float, queue_free_callback: bool) -> void:
	var tween: Tween = object.create_tween() as Tween
	
	# these value's shouldn't change for proper grow and shrink
	var start_length: float = 0.0
	var end_length: float = 3.0
	
	tween.tween_method(func(value: float):
		var current_scale = clamp(sin(value) * target_size, 1, target_size)
		object.scale.x = current_scale
		object.scale.y = current_scale
	, start_length, end_length, duration)
	
	if queue_free_callback:
		tween.tween_callback(object.queue_free)


func spiral_outward(object: Node2D, player: Player, cycles: float, distance: float, duration: float,
 queue_free_callback: bool):
	var tween: Tween = object.create_tween() as Tween
	
	# these value's shouldn't change
	var start_length: float = 0.0
	
	tween.tween_method(func(value: float):
		var percent = value / cycles
		var current_radius = percent * distance
		var current_direction = Vector2.RIGHT.rotated(value * TAU)
		
		if not player: 
			return
		
		object.global_position = player.global_position + (current_direction * current_radius)
	, start_length, cycles, duration)
	
	if queue_free_callback:
		tween.tween_callback(object.queue_free)


func sine_over_distance(object: Node2D, start_location: Vector2, target_location: Vector2, revolutions: float,
 peak_amplitude: float, distance: float, duration: float, queue_free_callback: bool) -> void:
	var tween: Tween = object.create_tween() as Tween
	
	# these value's shouldn't change
	var start_length: float = 0.0
	var cycle_length: float = 6.0 # 6 cycles for full S Sine
	var full_cycles: float = revolutions * cycle_length
	
	tween.tween_method(func(value: float):
		var percent = (value / full_cycles)
		var distance_to_move = (percent * distance)
		var target_direction = start_location.direction_to(target_location)
		var total_movement =  (target_direction * distance_to_move)
		var total_peak_amplitude = (target_direction.rotated(rad_to_deg(90)) * (sin(value) * peak_amplitude))
		
		object.global_position = start_location + total_movement + total_peak_amplitude
	, start_length, full_cycles, duration)
	
	if queue_free_callback:
		tween.tween_callback(object.queue_free)


## Shoots an object outward at a set direction and distance, and then slingshots back to the player position
## object: should always be self
## start_pos: should be that of the player
## target_pos: should be that of the cursor
## distance: how far you want to throw it
## duration: how long you want it to take to reach it's destination and come back
func boomerang(object: Node2D, player: Player, target_pos: Vector2, distance: float, duration: float,
 queue_free_callback: bool) -> void:
	var tween: Tween = object.create_tween() as Tween
	
	# these value's shouldn't change for proper boomerang effect.
	var start_length: float = 0.0
	var end_length: float = 3.0
	var center_of_cycle_for_switch: float = 1.8
	var start_pos = player.global_position
	
	tween.tween_method(func(value: float):
		if not player: return
		
		var switch: bool = false
		var target_direction: Vector2 = start_pos.direction_to(target_pos)
		var distance_travelled: Vector2 = (target_direction * (sin(value) * distance))
		
		# after the value hits the center of the cycle, it will switch how it handles distance/target angle
		# prior to switch it shoots towards the target position, when it hits said distance it switches
		# ensuring it always comes back to the player
		if value >= center_of_cycle_for_switch: switch = true
		
		if not switch:
			object.global_position = (start_pos + distance_travelled)
		else:
			target_direction = player.global_position.direction_to(object.global_position)
			distance_travelled = (target_direction * (sin(value) * object.global_position.distance_to(player.global_position)))
			object.global_position = (player.global_position + distance_travelled)
			
	, start_length, end_length, duration)
	
	if queue_free_callback:
		tween.tween_callback(object.queue_free)
