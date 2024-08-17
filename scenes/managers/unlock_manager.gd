extends Node
class_name UnlockManager


@export var experience_manager: ExperienceManager
@export var unlock_screen_scene: PackedScene
@export var player_upgrade_unlocks: Array[UpgradeUnlock]

var current_unlocks: Dictionary = {}
var unlock_pool: WeightedTable = WeightedTable.new()


func _ready():
	add_player_general_upgrades()
	GameEvents.player_leveled_up.connect(on_player_leveled_up)
	GameEvents.unlock_applied.connect(on_unlock_applied)


func add_player_general_upgrades() -> void:
	if player_upgrade_unlocks.is_empty():
		return
	
	for unlock in player_upgrade_unlocks:
		unlock_pool.add_item(unlock, calculate_unlock_weight(unlock))


func calculate_unlock_weight(unlock: Unlock) -> int:
	if unlock is AbilityUnlock:
		return 250

	match (unlock as UpgradeUnlock).rarity:
		Unlock.unlock_rarity.NORMAL: 
			return 500
		Unlock.unlock_rarity.UNCOMMON: 
			return 200
		Unlock.unlock_rarity.RARE: 
			return 100
		Unlock.unlock_rarity.EPIC: 
			return 10
		Unlock.unlock_rarity.LEGENDARY: 
			return 1
	
	return 500


func mass_add_to_unlock_pool(unlocks: Array) -> void:
	if unlocks.is_empty():
		return
	
	if not unlocks is Array[Unlock] && not unlocks is Array[AbilityUnlock] && not unlocks is Array[UpgradeUnlock]:
		return
	
	for unlock in unlocks:
		unlock_pool.add_item(unlock, calculate_unlock_weight(unlock))

 
func on_unlock_selected(unlock: Unlock):
	apply_unlock(unlock)


func apply_unlock(unlock: Unlock) -> void:
	var has_unlock: bool = current_unlocks.has(unlock.id)
	
	if not has_unlock:
		current_unlocks[unlock.id] = {
			"resource": unlock,
			"value": (unlock as UpgradeUnlock).value if unlock is UpgradeUnlock else 0.0,
			"current_value": (unlock as UpgradeUnlock).value if unlock is UpgradeUnlock else 0.0,
			"quantity": 1
		}
	else:
		current_unlocks[unlock.id]["quantity"] += 1
	
	if unlock.max_quantity > 0:
		var current_quantity: int = current_unlocks[unlock.id]["quantity"]
		if current_quantity == unlock.max_quantity:
			unlock_pool.remove_item(unlock)
	
	update_unlock_pool(unlock)
	GameEvents.emit_unlock_added(unlock, current_unlocks)


func update_unlock_pool(chosen_unlock: Unlock) -> void:
	if chosen_unlock is AbilityUnlock:
		var ability_unlock: AbilityUnlock = (chosen_unlock as AbilityUnlock)
		var controller_scene: AbilityController = ability_unlock.ability_controller_scene.instantiate() as AbilityController
		var unlock_list: Array[UpgradeUnlock] = controller_scene.unlock_list as Array[UpgradeUnlock]
		controller_scene.queue_free()
		if unlock_list.is_empty():
			return
		else:
			for unlock in unlock_list:
				unlock_pool.add_item(unlock, calculate_unlock_weight(unlock))


func pick_random_unlocks() -> Array[Unlock]:
	var chosen_unlocks: Array[Unlock] = []
	var unlock_count: WeightedTable = WeightedTable.new()
	unlock_count.add_item(2, 90)		# 90% chance
	unlock_count.add_item(3, 9)			# 9% Chance
	unlock_count.add_item(4, 1)			# 1% Chance
	
	
	for i in unlock_count.pick_item():
		if unlock_pool.items.size() == chosen_unlocks.size():
			break
		var chosen_unlock: Unlock = unlock_pool.pick_item(chosen_unlocks)
		chosen_unlocks.append(chosen_unlock)
	
	return chosen_unlocks


func on_player_leveled_up(current_level: int) -> void:
	var chosen_unlocks: Array[Unlock] = pick_random_unlocks()
	if chosen_unlocks.is_empty(): return
	
	var unlock_screen_instance: UnlockScreenUI = unlock_screen_scene.instantiate() as UnlockScreenUI
	add_child(unlock_screen_instance)
	
	unlock_screen_instance.set_unlocks(chosen_unlocks as Array[Unlock], current_unlocks)
	unlock_screen_instance.unlock_selected.connect(on_unlock_selected)


func on_unlock_applied(unlock: Unlock, current_value: float) -> void:
	current_unlocks[unlock.id]["current_value"] = current_value 
