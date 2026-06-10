## Parallax background system for race stages
## Creates layered scrolling backgrounds with stage-appropriate elements
extends Node2D

@onready var layer1: ParallaxLayer = $ParallaxLayer1
@onready var layer2: ParallaxLayer = $ParallaxLayer2
@onready var layer3: ParallaxLayer = $ParallaxLayer3

var scroll_speed := 50.0

func _ready() -> void:
	# Layer parallax multipliers (higher = moves slower = further away)
	if has_node("ParallaxLayer1"):
		$ParallaxLayer1.parallax_scale = 0.2
	if has_node("ParallaxLayer2"):
		$ParallaxLayer2.parallax_scale = 0.5
	if has_node("ParallaxLayer3"):
		$ParallaxLayer3.parallax_scale = 1.0

func _process(delta: float) -> void:
	# Scroll backgrounds based on Wario's movement
	var wario_pos := get_node_or_null("../Wario")
	if wario_pos == null:
		return
	
	var scroll_x := wario_pos.position.x * -0.3  # Negative because we scroll left as player moves right
	
	if has_node("ParallaxLayer1/Background"):
		$ParallaxLayer1/Background.position.x = scroll_x * 0.5
	if has_node("ParallaxLayer2/Midground"):
		$ParallaxLayer2/Midground.position.x = scroll_x * 0.8
	if has_node("ParallaxLayer3/Foreground"):
		$ParallaxLayer3/Foreground.position.x = scroll_x

func set_stage_theme(theme: String) -> void:
	match theme:
		"city":
			_set_city_theme()
		"park":
			_set_park_theme()
		"bowser":
			_set_bowser_theme()
		"dream":
			_set_dream_theme()

func _set_city_theme() -> void:
	if has_node("ParallaxLayer1/Background"):
		$ParallaxLayer1/Background.color = Color(0.25, 0.25, 0.3)
	if has_node("ParallaxLayer2/Midground"):
		$ParallaxLayer2/Midground.color = Color(0.35, 0.35, 0.4)

func _set_park_theme() -> void:
	if has_node("ParallaxLayer1/Background"):
		$ParallaxLayer1/Background.color = Color(0.3, 0.5, 0.25)
	if has_node("ParallaxLayer2/Midground"):
		$ParallaxLayer2/Midground.color = Color(0.4, 0.6, 0.3)

func _set_bowser_theme() -> void:
	if has_node("ParallaxLayer1/Background"):
		$ParallaxLayer1/Background.color = Color(0.4, 0.1, 0.05)
	if has_node("ParallaxLayer2/Midground"):
		$ParallaxLayer2/Midground.color = Color(0.5, 0.15, 0.08)

func _set_dream_theme() -> void:
	if has_node("ParallaxLayer1/Background"):
		$ParallaxLayer1/Background.color = Color(0.5, 0.25, 0.6)
	if has_node("ParallaxLayer2/Midground"):
		$ParallaxLayer2/Midground.color = Color(0.6, 0.35, 0.7)
