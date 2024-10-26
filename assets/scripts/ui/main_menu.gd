extends CanvasLayer

var companion_scene : PackedScene = preload("res://assets/scenes/ui/companion_choice.tscn")

var CreditsButton : Button
var MenuContainer : Container
var QuitButton : Button
var SettingsButton : Button
var StartButton : Button
var UIChirp : AudioStreamPlayer

func _ready() -> void:
	CreditsButton = $ButtonContainer/Credits
	MenuContainer = $ButtonContainer
	QuitButton = $ButtonContainer/Quit
	SettingsButton = $ButtonContainer/Settings
	StartButton = $ButtonContainer/Start
	UIChirp = $UI
	
	CreditsButton.connect("pressed", _on_credits_pressed)
	QuitButton.connect("pressed", _on_quit_pressed)
	SettingsButton.connect("pressed", _on_settings_pressed)
	StartButton.connect("pressed", _on_start_pressed)
	
	StartButton.grab_focus()
	_generate_neighbors()

# Needed to generate UI handling for the buttons.
func _generate_neighbors() -> void:
	var children : Array = MenuContainer.get_children() as Array[Button]
	var child_count : int = children.size()
	for child in children:
		var i : int = children.find(child)
		if child_count > 1:
			if i == 0:
				child.focus_neighbor_bottom = children[i + 1].get_path()
			elif i == (child_count - 1):
				child.focus_neighbor_top = children[i - 1].get_path()
			else:
				child.focus_neighbor_top = children[i - 1].get_path()
				child.focus_neighbor_bottom = children[i + 1].get_path()

# Signal handlers for credit, quit, setting, and start buttons.
func _on_credits_pressed() -> void:
	_play_chirp()

func _on_quit_pressed() -> void:
	_play_chirp()

func _on_settings_pressed() -> void:
	_play_chirp()

func _on_start_pressed() -> void:
	_play_chirp()
	Global.save_loaded = true
	Global.change_levels(companion_scene)

func _play_chirp() -> void:
	UIChirp.play()
