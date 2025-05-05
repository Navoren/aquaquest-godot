class_name Character
extends Node

enum Name {
	APOLLO,
	PHEONIX,
	TRUCY
}

const CHARACTER_DETAILS : Dictionary = {
	Name.APOLLO: {
		"name" : "Apollo",
		"gender" : "male",
		"sprite_frames" : null
	},
	Name.PHEONIX: {
		"name" : "Pheonix",
		"gender" : "male",
		"sprite_frames" : preload("res://resources/pheonix_sprites.tres")
	},
	Name.TRUCY: {
		"name" : "Trucy",
		"gender" : "female",
		"sprite_frames" : preload("res://resources/trucy_sprites.tres")
	},
}

static func get_enum_from_string(string_value: String) -> int:
	var upper_string = string_value.to_upper()
	if Name.has(upper_string):
		return Name[upper_string]
	else:
		push_error("Invalid Character name: " + string_value)
		return -1	
