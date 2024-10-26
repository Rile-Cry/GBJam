extends CharacterBody2D


const SPEED : int = 1

var AnimTree : AnimationTree
var AnimPlayer : AnimationPlayer
var Sprite : Sprite2D

var interacting : Array = [false, false]
var facing_right : bool = true
var idle : bool = true
var running : bool = false

var _state_machine : AnimationNodeStateMachinePlayback


func _ready() -> void:
	AnimTree = $AnimationTree
	AnimPlayer = $AnimationPlayer
	Sprite = $Sprite2D
	
	_state_machine = AnimTree["parameters/playback"]
	
	add_to_group("player")

func _physics_process(delta: float) -> void:
	animation()
	movement(delta)

# Needed to animate the player
func animation() -> void:
	# Needed to handle the transition from idle to running
	AnimTree.set("parameters/conditions/idle", idle)
	AnimTree.set("parameters/conditions/running", running)
	
	# ToDo: try to make this process less redundant
	# Currently takes an array of length 2 to handle the transition from idle to interacting
	if _state_machine.get_current_node() == "idle" and (interacting[0] and interacting[1]):
		interacting[0] = false
	elif _state_machine.get_current_node() == "idle" and interacting[1]:
		interacting[1] = false
	
	# Necessary to allow the sprite to flip depending on which way the player was
	#  moving last.
	if facing_right:
		Sprite.flip_h = false
	else:
		Sprite.flip_h = true

# Containing all the movement functionality to make it easier to manipulate or change
func movement(delta: float) -> void:
	# Essentially determining if the player is in the 'interacting' animation
	var doing_something = interacting[0] or interacting[1]
	
	# If the player is 'interacting' then no movement will occur, else moves the player
	#  according to the following block.
	if Input.is_action_pressed("move_right") and not doing_something:
		velocity.x = SPEED / delta
		facing_right = true
		idle = false
		running = true
	elif Input.is_action_pressed("move_left") and not doing_something:
		velocity.x = -SPEED / delta
		facing_right = false
		idle = false
		running = true
	else:
		velocity = Vector2(0, 0)
		idle = true
		running = false
	
	# Finally allow the player to move
	move_and_slide()

# Needed for the animation function, since without it the animation doesn't happen at all?
func interact() -> void:
	_state_machine.travel("interact")
	interacting = [true, true] 
