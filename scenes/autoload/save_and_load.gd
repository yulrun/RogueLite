extends Node


const OPTIONS_FILE_PATH: String = "user://opt.yrg"
const META_DATA_FILE_PATH: String = "user://md.yrg"

var current_options: Dictionary = {
	"fullscreen": false,
	"sound_effects_volume": 1.0,
	"music_volume": 1.0
}

func _ready() -> void:
	load_options()


## Apply to the stored_meta_data in MetaProgression
func load_meta_data() -> Variant:
	return _load_variant_from_file(META_DATA_FILE_PATH)


## Pass in the stored_meta_data dictionary in MetaProgression
func save_meta_data(variant: Variant) -> void:
	_save_variant_to_file(META_DATA_FILE_PATH, variant)


## Called only within this Script
func load_options() -> void:
	var loaded_data = _load_variant_from_file(OPTIONS_FILE_PATH)
	if loaded_data == null:
		return
		
	current_options = loaded_data
	
	var fullscreen: bool = current_options["fullscreen"] as bool
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen else \
	DisplayServer.WINDOW_MODE_WINDOWED)
	
	Util.set_bus_volume_percent("Sound Effects", current_options["sound_effects_volume"])
	Util.set_bus_volume_percent("Music", current_options["music_volume"])


## Called from OptionsMenu when going back, to save any changes
func save_options() -> void:
	var is_fullscreen: bool = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)
	current_options["fullscreen"] = is_fullscreen
	current_options["sound_effects_volume"] = Util.get_bus_volume_percent("Sound Effects")
	current_options["music_volume"] = Util.get_bus_volume_percent("Music")
	
	_save_variant_to_file(OPTIONS_FILE_PATH, current_options)


## Internal function
func _save_variant_to_file(file_path: String, variant: Variant) -> void:
	FileAccess.open(file_path, FileAccess.WRITE).store_var(variant)


## Internal function
func _load_variant_from_file(file_path: String) -> Variant:
	if not FileAccess.file_exists(file_path):
		return
		
	return FileAccess.open(file_path, FileAccess.READ).get_var()
