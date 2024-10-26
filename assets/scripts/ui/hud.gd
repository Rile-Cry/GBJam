extends TextureRect

# ToDo: Setup the inventory and hud handling after dealing with the travel system

func _ready() -> void:
	Global.pass_hud(self)
