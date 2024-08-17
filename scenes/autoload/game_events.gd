extends Node


signal experience_object_collected(experience: float)
signal unlock_added(unlock: Unlock, current_unlocks: Dictionary)
signal unlock_applied(unlock: Unlock, current_value: float)
signal player_damaged()
signal player_leveled_up(level: int)


func emit_experience_object_collected(experience: float) -> void: 
	experience_object_collected.emit(experience)


func emit_unlock_added(unlock: Unlock, current_unlocks: Dictionary) -> void:
	unlock_added.emit(unlock, current_unlocks)


func emit_unlock_applied(unlock: Unlock, current_value: float) -> void:
	unlock_applied.emit(unlock, current_value)


func emit_player_damaged() -> void:
	player_damaged.emit()

func emit_player_leveled_up(level: int) -> void:
	player_leveled_up.emit(level)
