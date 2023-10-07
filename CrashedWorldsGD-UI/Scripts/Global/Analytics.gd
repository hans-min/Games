extends Node
class_name Analytics # ALTC
# ------------------------------------------------------------------------------ PUBLIC PROPERTIES
var player_jump : int = 0
var player_craft_done : int = 0
var player_damage_done : int = 0
var player_damage_taken : int = 0
var player_bloc_mined : int = 0
var player_bloc_placed : int = 0
var player_item_collected : int = 0

var world_biome: String = ""
var world_seed : int = 0 
var world_time_played : int = 0 # ms
var world_escaped : bool = false

var dict : Dictionary # actual dictionary

signal game_over
# ------------------------------------------------------------------------------ CUSTOM METHODS

func get_data_dict() -> Dictionary:
	dict = {
		"player_jump" : player_jump,
		"player_craft_done" : player_craft_done,
		"player_damage_done" : player_damage_done,
		"player_damage_taken" : player_damage_taken,
		"player_bloc_mined" : player_bloc_mined,
		"player_bloc_placed" : player_bloc_placed,
		"player_item_collected" : player_item_collected,
		
		"world_biome" : world_biome,
		"world_seed" : world_seed,
		"world_time_played" : world_time_played,
		"world_escaped" : world_escaped
	}
	return dict


# ------------------------------------------------------------------------------ SIGNALS


