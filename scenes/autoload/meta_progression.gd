extends Node


const MIN_LEVEL_FOR_META_CURRENCY: int = 5
const STAGE_1_CURRENCY_INCREASE: int = 10
const STAGE_2_CURRENCY_INCREASE: int = 15
const STAGE_3_CURRENCY_INCREASE: int = 20

const MIN_CURRENCY_AMOUNT: int = 1
const STAGE_1_CURRENCY_AMOUNT: int = 2
const STAGE_2_CURRENCY_AMOUNT: int = 4
const STAGE_3_CURRENCY_AMOUNT: int = 6

var stored_meta_data: Dictionary = {
	"meta_unlock_currency": 0,
	"meta_unlocks": {
	}
}


func _ready() -> void:
	GameEvents.player_leveled_up.connect(on_player_leveled_up)
	
	load_meta_data()


func load_meta_data() -> void:
	var loaded_data = SaveAndLoad.load_meta_data()
	if loaded_data == null:
		return
	
	stored_meta_data = loaded_data
	print(loaded_data)


func save() -> void:
	SaveAndLoad.save_meta_data(stored_meta_data)


func add_meta_unlock(unlock: MetaUnlock) -> void:
	if not stored_meta_data["meta_unlocks"].has(unlock.id):
		stored_meta_data["meta_unlocks"][unlock.id] = {
			"resource": unlock,
			"quantity": 0
		}
		
	stored_meta_data["meta_unlocks"][unlock.id]["quantity"] += 1


func get_unlock_resource(unlock_id: String) -> MetaUnlock:
	return stored_meta_data["meta_unlocks"][unlock_id]["resource"] as MetaUnlock


func on_player_leveled_up(level: int) -> void:
	var currency_increase: int = MIN_CURRENCY_AMOUNT
	
	if level >= STAGE_1_CURRENCY_INCREASE:
		currency_increase = STAGE_1_CURRENCY_AMOUNT
		if level >= STAGE_2_CURRENCY_INCREASE:
			currency_increase = STAGE_2_CURRENCY_AMOUNT
			if level >= STAGE_3_CURRENCY_INCREASE:
				currency_increase = STAGE_3_CURRENCY_AMOUNT
	
	stored_meta_data["meta_unlock_currency"] += currency_increase
	Util.instantiate_floating_text(Util.get_player(), "+%s MC" % currency_increase, FloatingText.text_type.EXPERIENCE)
	SaveAndLoad.save_meta_data(stored_meta_data)
