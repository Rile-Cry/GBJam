extends AnimatableBody2D
# ToDo: Refactor

const MAX_SPEED : int = 20
const MAX_COUNTER : int = 10
const ACCELERTATION : int = 2

var Airlock : Area2D
var AirlockSprite : Sprite2D
var EffectPlayer : AudioStreamPlayer
var EnginePlayer : AudioStreamPlayer
var MusicPlayer : AudioStreamPlayer
var AnimTree : AnimationTree
var AnimWait : Timer
var TravelWait : Timer
var Computer : Area2D
var UpgradeTerminal : Area2D
var current_song : String = "calm"
var speed : int = 0
var current_zone : int = 1
var accel_counter : int = 0
var accelerate : bool = false
var current_zone_type : Global.ZoneTypes

var interacting : Dictionary = {
	"AirlockArea": false,
	"Computer": false,
	"UpgradeTerminal": false,
}
var sounds : Dictionary = {
	"airlock_open": "res://assets/imports/audio/sfx/sfx_door.mp3",
	"airlock_close": "res://assets/imports/audio/sfx/sfx_door_close.mp3",
	"engine_start": "res://assets/imports/audio/sfx/sfx_rocket_acceleration.mp3",
	"travelling": "res://assets/imports/audio/sfx/sfx_rocket_levitating.mp3",
	"engine_stop": "res://assets/imports/audio/sfx/sfx_rocket_slowdown.mp3",
}

var music : Dictionary = {
	"theme": "res://assets/imports/audio/music/music1_loop.wav",
	"calm": "res://assets/imports/audio/music/music2_loop.wav",
	"space": "res://assets/imports/audio/music/music3_loop.wav",
}

func _ready() -> void:
	Airlock = $Airlock/AirlockArea
	AirlockSprite = $Airlock/Sprite2D
	AnimWait = $AnimWait
	AnimTree = $AnimationTree
	TravelWait = $TravelWait
	EffectPlayer = $InteractEffect
	EnginePlayer = $Engine
	MusicPlayer = $Music
	Computer = $Computer
	UpgradeTerminal = $UpgradeTerminal
	
	MusicPlayer.stream = load(music[current_song])
	MusicPlayer.play()
	
	TravelWait.connect("timeout", _travel_finished)
	EnginePlayer.connect("finished", _on_engine_audio_finished)
	#current_zone_type = Global.zones["zone_1"]["type"]

func _physics_process(delta):
	_hover()
	_grab_input()
	_movement()
	
	if accel_counter <= 0:
		accel_counter = MAX_COUNTER
		accelerate = true
	else:
		accel_counter -= 1
		accelerate = false

func _hover():
	var overlap : Array
	for item in [Airlock, Computer, UpgradeTerminal]:
		overlap = item.get_overlapping_bodies()
		if overlap.size() > 0:
			if overlap[overlap.size() - 1].name == "Player":
				interacting[item.name] = true
			else:
				interacting[item.name] = false
		else:
			interacting[item.name] = false

func _grab_input() -> void:
	for item in interacting.keys():
		if interacting[item]:
			if Input.is_action_just_pressed("interact"):
				_interact_with(item)

func _movement() -> void:
	if Global.travelling:
		if speed < MAX_SPEED and accelerate:
			speed += ACCELERTATION
	else:
		if speed > 0 and accelerate:
			speed -= ACCELERTATION
	
	position.x += speed

func _travel_finished() -> void:
	Global.travelling = false
	current_zone += 1
	current_zone_type = Global.zones["zone_%s" % current_zone]["type"]
	AnimTree.set("parameters/conditions/travelling", false)
	AnimTree.set("parameters/conditions/not_travelling", true)
	EnginePlayer.stream = load(sounds["engine_stop"])
	MusicPlayer.stream = load(music["calm"])
	EnginePlayer.play()
	MusicPlayer.play()

func _interact_with(interaction : String) -> void:
	match(interaction):
		"AirlockArea":
			if not Global.travelling:
				_airlock_interaction()
		"Computer":
			if AirlockSprite.frame == 0:
				_computer_interaction()
		"UpgradeTerminal":
			_upgrade_interaction()
		_:
			print("Interacting with nothing")

func _airlock_interaction() -> void:
	get_tree().call_group("player", "interact")
	AnimWait.wait_time = 1
	AnimWait.start()
	await AnimWait.timeout
	if AirlockSprite.frame == 0:
		EffectPlayer.stream = Global.load_mp3(sounds["airlock_open"])
		AirlockSprite.frame = 1
	else:
		AirlockSprite.frame = 0
		EffectPlayer.stream = Global.load_mp3(sounds["airlock_close"])
	
	EffectPlayer.play()

func _computer_interaction() -> void:
	get_tree().call_group("player", "interact")
	Global.travelling = true
	AnimTree.set("parameters/conditions/travelling", true)
	AnimTree.set("parameters/conditions/not_travelling", false)
	MusicPlayer.stream = load(music["theme"])
	EnginePlayer.stream = load(sounds["engine_start"])
	MusicPlayer.play()
	EnginePlayer.play()
	TravelWait.wait_time = 5
	TravelWait.start()

func _upgrade_interaction() -> void:
	get_tree().call_group("player", "interact")
	print(current_zone_type)

func _on_engine_audio_finished() -> void:
	if EnginePlayer.stream == load(sounds["engine_start"]):
		EnginePlayer.stream = load(sounds["travelling"])
		EnginePlayer.play()
