extends AudioStreamPlayer
class_name RandomStreamPlayerComponent


@export var streams: Array[AudioStream]
@export var randomize_pitch: bool = true

const MIN_RAND_PITCH: float = 0.9
const MAX_RAND_PITCH: float = 1.1


func play_random():
	if streams.is_empty():
		return
		
	if randomize_pitch:
		pitch_scale = randf_range(MIN_RAND_PITCH, MAX_RAND_PITCH)
	else:
		pitch_scale = 1.0
		
	stream = streams.pick_random()
	play()
