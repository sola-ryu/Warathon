## Post-race results screen
extends Control

@onready var results_label: Label = $VBoxContainer/ResultsLabel
@onready var score_label: Label = $VBoxContainer/ScoreLabel
@onready var honesty_label: Label = $VBoxContainer/HonestyLabel
@onready var chaos_label: Label = $VBoxContainer/ChaosLabel
@onready var back_button: Button = $VBoxContainer/BackButton

func _ready() -> void:
	_update_results()

func _update_results() -> void:
	results_label.text = "🏆 Wario Wins! ...Again."
	score_label.text = "Cheating Score: %d" % int(GameData.total_score)
	honesty_label.text = "Honesty Rating: 0%% — Badge of Honor"
	chaos_label.text = "Peak Chaos Multiplier: x%.1f" % GameData.current_chaos_multiplier

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/main/menu.tscn")
