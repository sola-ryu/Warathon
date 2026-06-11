## Simple opponent sprite renderer — colored rectangles with names and expressions
## Each opponent gets a unique visual identity
extends Node2D

@onready var name_label: Label = $NameLabel
@onready var expression_label: Label = $ExpressionLabel
@onready var body_rect: ColorRect = $Body

const OPPONENT_VISUALS := {
	"Mario": {"color": Color(0.9, 0.2, 0.2), "expression": "😤", "height": 50},
	"Luigi": {"color": Color(0.2, 0.7, 0.2), "expression": "😰", "height": 55},
	"Peach": {"color": Color(1.0, 0.6, 0.8), "expression": "😐", "height": 45},
	"Toad": {"color": Color(1.0, 0.9, 0.3), "expression": "😠", "height": 30},
	"Yoshi": {"color": Color(0.3, 0.9, 0.3), "expression": "🤤", "height": 48},
	"Donkey Kong": {"color": Color(0.5, 0.3, 0.1), "expression": "😡", "height": 65},
	"Bowser": {"color": Color(0.8, 0.2, 0.1), "expression": "🔥", "height": 70},
	"Waluigi": {"color": Color(0.4, 0.1, 0.6), "expression": "😏", "height": 58},
}

func configure(opponent_name: String) -> void:
	var visual: Dictionary = OPPONENT_VISUALS.get(opponent_name)
	if visual == null:
		return
	
	body_rect.color = visual["color"]
	name_label.text = opponent_name
	expression_label.text = visual["expression"]
	
	var h: int = visual["height"]
	body_rect.custom_minimum_size = Vector2(30, h)
	position.y = 560 - h
