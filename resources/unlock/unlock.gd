extends Resource
class_name Unlock


enum unlock_rarity {
	NORMAL,
	UNCOMMON,
	RARE,
	EPIC,
	LEGENDARY
}


@export var id: String
@export var max_quantity: int = 5	## If max_quanity is 0, unlimited
@export var rarity: unlock_rarity = unlock_rarity.NORMAL
@export var name: String
@export_multiline var description: String
