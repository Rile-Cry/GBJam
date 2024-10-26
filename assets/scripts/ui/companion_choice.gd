extends CanvasLayer

var ship_scene : PackedScene = preload("res://assets/scenes/zones/ship_zone_one.tscn")

var BirdButton : Button
var ButtonContainer : HBoxContainer
var DogButton : Button
var FishButton : Button


func _ready() -> void:
	BirdButton = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Bird/Button
	DogButton = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Dog/Button
	FishButton = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Fish/Button
	ButtonContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer
	
	BirdButton.connect("pressed", _on_bird_picked)
	DogButton.connect("pressed", _on_dog_picked)
	FishButton.connect("pressed", _on_fish_picked)
	
	DogButton.grab_focus()

# Private function that generates the ui handling for the three buttons
func _generate_neighbors() -> void:
	var children : Array = ButtonContainer.get_children() as Array[VBoxContainer]
	var child_count : int = children.size()
	for child in children:
		var i : int = children.find(child)
		if child_count > 1:
			if i == 0:
				child.focus_neighbor_right = children[i + 1].get_child(1).get_path()
			elif i == (child_count - 1):
				child.focus_neighbor_left = children[i - 1].get_child(1).get_path()
			else:
				child.focus_neighbor_left = children[i - 1].get_child(1).get_path()
				child.focus_neighbor_right = children[i + 1].get_child(1).get_path()

# _on_(bird/dog/fish)_picked are just signal handlers for their respective buttons
func _on_bird_picked() -> void:
	Global.companion = Global.Companion.BIRD
	_next_scene()

func _on_dog_picked() -> void:
	Global.companion = Global.Companion.DOG
	_next_scene()

func _on_fish_picked() -> void:
	Global.companion = Global.Companion.FISH
	_next_scene()

# Needed to define the next scene which can then be used in each buttons signal function
func _next_scene() -> void:
	Global._generate_map()
	Global.change_levels(ship_scene)
