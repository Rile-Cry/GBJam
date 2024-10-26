extends Node2D
# ToDo: Refactor

var Player : CharacterBody2D
var Ship : Node2D
var SpawnPoint : Node2D

var automatons : Dictionary = {
	Global.Companion.DOG: "res://assets/scenes/entities/dog.tscn",
	Global.Companion.BIRD: "res://assets/scenes/entities/bird.tscn",
	Global.Companion.FISH: "res://assets/scenes/entities/fish.tscn",
}

var music : Dictionary = {
	"theme": "res://assets/imports/audio/music/music1_loop.wav",
	"calm": "res://assets/imports/audio/music/music2_loop.wav",
	"space": "res://assets/imports/audio/music/music3_loop.wav",
}

func _ready() -> void:
	Player = $ShipT1/Player
	Ship = $ShipT1
	SpawnPoint = $ShipT1/AutomatonSpawn
	
	var companion_data : PackedScene = load(automatons[Global.companion])
	var companion : CharacterBody2D = companion_data.instantiate()
	companion.position = SpawnPoint.position
	Ship.add_child(companion)

