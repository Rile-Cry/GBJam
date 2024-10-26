extends Node

# Preload main menu to start the game quicker, same for the space level
var main_menu : PackedScene = preload("res://assets/scenes/zones/main_menu.tscn")

enum Companion {
	DOG,
	BIRD,
	FISH,
}
enum RegionType {
	REGION_1,
	REGION_2,
	REGION_3,
}
enum ZoneTypes {
	ASTEROID,
	PLANET,
	GAS_CLOUD,
	BLACK_HOLE,
	HOME_WORLD,
}

const WINDOW_SIZE : int = 3
const MAX_ZONES : int = 30

var companion : Companion
var zones : Dictionary = {}
var save_loaded : bool = false
var travelling : bool = false
var crystal : int = 0
var current_zone : int = 1
var difficulty : int = 0
var fuel : int = 0
var lumite : int = 0
var time_cycle : int = 1
var unobtainium : int = 0
var game : Node
var HUD : TextureRect
var current_region : RegionType = RegionType.REGION_1


func _ready() -> void:
	# Get the game scene which will be used to handle scene switching.
	game = get_tree().root.get_child(1)
	var load_scene = main_menu.instantiate()
	game.add_child.call_deferred(load_scene)
	
	get_window().size = Vector2i(160 * WINDOW_SIZE, 144 * WINDOW_SIZE)

func _process(delta : float) -> void:
	debug_input()
	material_overflow()
	update_hud()

func debug_input() -> void:
	if Input.is_action_just_released("debug_day"):
		time_cycle += 1
	elif Input.is_action_just_released("debug_lumite"):
		lumite += 1
	elif Input.is_action_just_released("debug_gem"):
		crystal += 1
	elif Input.is_action_just_released("debug_unobtainium"):
		unobtainium += 1
	elif Input.is_action_just_released("debug_fuel"):
		fuel += 1

func material_overflow() -> void:
	if time_cycle > 99:
		time_cycle = 99
	if crystal > 99:
		crystal = 99
	if lumite > 99:
		lumite = 99
	if unobtainium > 99:
		unobtainium = 99
	if fuel > 99:
		fuel = 99

func update_hud() -> void:
	if HUD != null:
		for child in HUD.get_children():
			if child.name == "Days":
				if time_cycle < 10:
					child.text = "0" + str(time_cycle)
				else:
					child.text = str(time_cycle)
			elif child.name == "Lumite":
				child.text = str(lumite)
			elif child.name == "Gem":
				child.text = str(crystal)
			elif child.name == "Unobtainium":
				child.text = str(unobtainium)
			elif child.name == "Fuel":
				child.text = str(fuel)

# ToDo: Remember why I needed this function
func pass_hud(node : TextureRect) -> void:
	HUD = node

# Helps make the transition between scenes easier.
func change_levels(load_scene: PackedScene) -> void:
	game.remove_child(game.get_child(0))
	
	var instantiated_scene = load_scene.instantiate()
	game.add_child(instantiated_scene)

"""
func save_data() -> Dictionary:
	var save_dict : Dictionary = {
		"crystal": crystal,
		"fuel": fuel,
		"lumite": lumite,
		"unobtainium": unobtainium,
		"timecycle": time_cycle,
	}
	
	return save_dict

func save_game() -> void:
	var game_save : FileAccess = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string : String = JSON.stringify(save_data())
	game_save.store_line(json_string)

func load_game() -> void:
	var game_save : FileAccess = FileAccess.open("user://savegame.save", FileAccess.READ)
	### ToDo: Optimize and figure out the save system . . . 
"""

# Needed for generating the star map that'll be used in the future travel system
func _generate_map() -> void:
	var i : int = 1
	var homeworld_generated : bool = false
	while i < MAX_ZONES:
		var temp_dict : Dictionary = {}
		temp_dict["coords"] = Vector2(randi_range(0, 1000), randi_range(0, 1000))
		
		zones["zone_%s" % i] = temp_dict
		i += 1
	
	print(zones)
