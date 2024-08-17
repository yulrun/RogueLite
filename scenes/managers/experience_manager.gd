extends Node
class_name ExperienceManager

signal experience_updated(current_experience: float, target_experience: float)

const TARGET_EXPERIENCE_GROWTH = 1

var current_experience: float = 0
var current_level: int = 1
var target_experience: float = 1


func _ready():
	GameEvents.experience_object_collected.connect(on_experience_object_collected)


func increment_experience(experience: float) -> void:
	current_experience = min(current_experience + experience, target_experience)
	experience_updated.emit(current_experience, target_experience)
	if current_experience == target_experience:
		current_level += 1
		target_experience += TARGET_EXPERIENCE_GROWTH
		current_experience = 0
		experience_updated.emit(current_experience, target_experience)
		GameEvents.emit_player_leveled_up(current_level)


func on_experience_object_collected(experience: float) -> void:
		increment_experience(experience)
