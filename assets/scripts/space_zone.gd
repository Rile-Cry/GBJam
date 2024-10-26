extends Node
# ToDo: Refactor

var travel_point : PackedScene = preload("res://assets/scenes/entities/travel_point.tscn")

var BackgroundParallax : Sprite2D
var BackParallax : Sprite2D
var MiddleParallax : Sprite2D
var FrontParallax : Sprite2D

func _ready() -> void:
	BackgroundParallax = $CanvasLayer/ParallaxBackground/ParallaxLayer/Background
	BackParallax = $CanvasLayer/ParallaxBackground/ParallaxLayer/Back
	MiddleParallax = $CanvasLayer/ParallaxBackground/ParallaxLayer/Middle
	FrontParallax = $CanvasLayer/ParallaxBackground/ParallaxLayer/Front
