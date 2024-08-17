extends CanvasLayer
class_name UnlockScreenUI

signal unlock_selected(unlock: Unlock)

@export var unlock_card_scene: PackedScene
@onready var card_container: HBoxContainer = %CardContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	get_tree().paused = true


func set_unlocks(unlocks: Array[Unlock], current_unlocks: Dictionary) -> void:
	var delay: float = 0.0
	var unlock_card_instance: PanelContainer
	for unlock in unlocks:
		unlock_card_instance = unlock_card_scene.instantiate() as UnlockCard
		card_container.add_child(unlock_card_instance)
		unlock_card_instance.set_unlock(unlock, current_unlocks)
		unlock_card_instance.play_in_animaiton(delay)
		unlock_card_instance.selected.connect(on_unlock_selected.bind(unlock))
		delay += 0.2


func on_unlock_selected(unlock: Unlock):
	unlock_selected.emit(unlock)
	animation_player.play("fade_out")
	await animation_player.animation_finished
	get_tree().paused = false
	queue_free()
