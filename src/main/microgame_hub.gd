## Microgame hub — WarioWare-style mini-games between stages
extends Control

@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var game_list: VBoxContainer = $VBoxContainer/GameList
@onready var back_button: Button = $VBoxContainer/BackButton
@onready var timer_label: Label = $TimerLabel

# Available microgames
const GAMES := [
	{"name": "Stealth Sandwich", "icon": "🥪", "desc": "Grab food without being seen", "duration": 10},
	{"name": "Peel Master", "icon": "🍌", "desc": "Place banana peels on specific runners", "duration": 15},
	{"name": "Disguise", "icon": "🎭", "desc": "Become a spectator to reach the finish", "duration": 20},
	{"name": "Bridge Builder", "icon": "🌉", "desc": "Build a shortcut from random objects", "duration": 12},
]

var current_game := -1
var game_active := false
var game_timer := 0.0
var game_score := 0

func _ready() -> void:
	_populate_game_list()

func _populate_game_list() -> void:
	for game in GAMES:
		var btn := Button.new()
		btn.text = "%s %s — %s" % [game["icon"], game["name"], game["desc"]]
		btn.size_flags_horizontal = Control.SIZE_FILL
		btn.custom_minimum_size = Vector2(500, 60)
		btn.add_theme_font_size_override("font_size", 18)
		btn.pressed.connect(func(): _start_game(GAMES.find(game)))
		game_list.add_child(btn)

func _start_game(idx: int) -> void:
	current_game = idx
	var game: Dictionary = GAMES[idx]
	
	# Transition to microgame scene
	if idx == 0:
		get_tree().change_scene_to_file("res://src/main/microgame_stealth.tscn")
	elif idx == 1:
		get_tree().change_scene_to_file("res://src/main/microgame_peel.tscn")
	elif idx == 2:
		get_tree().change_scene_to_file("res://src/main/microgame_disguise.tscn")
	elif idx == 3:
		get_tree().change_scene_to_file("res://src/main/microgame_bridge.tscn")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/main/menu.tscn")
