extends Node2D

# ToDo: Come back to this after getting the travel map system dealt with

const zone_type : Dictionary = {
	Global.ZoneTypes.ASTEROID: "res://assets/imports/sprites/travel_points/asteroids.png",
	Global.ZoneTypes.BLACK_HOLE: "res://assets/imports/sprites/travel_points/black_hole.png",
	Global.ZoneTypes.GAS_CLOUD: "res://assets/imports/sprites/travel_points/gas_cloud.png",
	Global.ZoneTypes.HOME_WORLD: "res://assets/imports/sprites/travel_points/home_world.png",
	Global.ZoneTypes.PLANET: "res://assets/imports/sprites/travel_points/planet.png",
}

var Sprite : Sprite2D
var current_type : Global.ZoneTypes

func _ready() -> void:
	Sprite = $Sprite2D
	
	current_type = Global.zones[name]["type"]
	Sprite.texture = load(zone_type[current_type])
