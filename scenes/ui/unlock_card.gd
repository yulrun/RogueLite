extends PanelContainer
class_name UnlockCard


signal selected

@onready var type_label: Label = %TypeLabel
@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hover_animation_player: AnimationPlayer = $HoverAnimationPlayer

@export var ability_unlock_title_color: Color = Color.WHITE

var disabled: bool = false


func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)


func play_in_animaiton(delay: float = 0) -> void:
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	animation_player.play("in")


func play_discard_animation() -> void:
	animation_player.play("discard")


func set_unlock(unlock: Unlock, current_unlocks: Dictionary) -> void:
	name_label.text = unlock.name
	description_label.text = unlock.description
	
	if unlock.id.begins_with("player"):
		type_label.text = "Player Boost"
	elif unlock.id.begins_with("ability"):
		type_label.text = "New Ability!"
	elif unlock.id.begins_with("axe"):
		type_label.text = "Axe Upgrade"
	elif unlock.id.begins_with("sword"):
		type_label.text = "Sword Upgrade"
		
	
	if unlock is AbilityUnlock:
		set_ability_unlock_theme()
		%ValueLabel.queue_free()
		%QuantityLabel.queue_free()
	
	if unlock is UpgradeUnlock:
		var max_string: String = str(unlock.max_quantity) if unlock.max_quantity > 0 else "\u221E"
		if current_unlocks.has(unlock.id):
			var current_value: float = current_unlocks[unlock.id]["current_value"]
			var increase_value: float = unlock.value + current_value
			%ValueLabel.text = str("%2.1f" % current_value + "% -> " + ("%2.1f" % increase_value) + "%")
			%QuantityLabel.text = str(current_unlocks[unlock.id]["quantity"]) + "/" + max_string
		else:
			%ValueLabel.text = str("0%" + " -> " + ("%2.1f" % unlock.value) + "%")
			%QuantityLabel.text = "0/" + max_string


func set_ability_unlock_theme() -> void:
	set("theme_type_variation", "AbilityPanelContainer")
	name_label.set("theme_override_colors/font_color", ability_unlock_title_color)


func select_card() -> void:
	disabled = true
	animation_player.play("selected")
	
	for other_card in get_tree().get_nodes_in_group("unlock_card") as Array[UnlockCard]:
		if other_card == self:
			continue
		other_card.play_discard_animation()
	
	await animation_player.animation_finished
	selected.emit()


func on_gui_input(event: InputEvent) -> void:
	if disabled:
		return
		
	if event.is_action_pressed("left_click"):
		select_card()


func on_mouse_entered() -> void:
	if disabled:
		return
		
	hover_animation_player.play("grow")
