## Main menu screen
extends Control

@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var start_button: Button = $VBoxContainer/StartButton
@onready var mode_selector: OptionButton = $VBoxContainer/ModeSelector

func _ready() -> void:
	mode_selector.clear()
	mode_selector.add_item("WARATHON — Story Mode")
	mode_selector.add_item("CHEAT FEVER — Arcade Mode")
	mode_selector.add_item("WALUIGI'S RETRATHON — Rival Race")
	mode_selector.add_item("MICROGAMES — Cheat Mini-Games")

func _on_start_button_pressed() -> void:
	var mode: String = mode_selector.get_item_text(mode_selector.get_selected())
	if "Story" in mode:
		get_tree().change_scene_to_file("res://src/main/race.tscn")
	elif "Fever" in mode:
		get_tree().change_scene_to_file("res://src/main/race.tscn")
	elif "Retrathon" in mode:
		get_tree().change_scene_to_file("res://src/main/race.tscn")
	else:
		get_tree().change_scene_to_file("res://src/main/microgame_hub.tscn")

func _process(_delta: float) -> void:
	# Title bob animation
	if title_label:
		title_label.position.y = 120 + sin(Time.get_ticks_msec() / 500.0) * 8
