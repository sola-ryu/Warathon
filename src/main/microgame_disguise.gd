## Microgame: Disguise — become a spectator to reach the finish line
## WarioWare-style stealth game with transformation mechanic
extends Control

@onready var timer_label: Label = $TimerLabel
@onready var score_label: Label = $ScoreLabel
@onready var status_label: Label = $StatusLabel
@onready var start_button: Button = $StartButton

var game_active := false
var time_left := 20.0
var score := 0
var is_disguised := false
var suspicion_level := 0.0
const MAX_SUSPICION := 100.0
var distance_to_finish := 100.0  # percentage

const DISGUISE_COLORS := [
	Color(0.8, 0.6, 0.4),  # spectator 1
	Color(0.5, 0.7, 0.9),  # spectator 2
	Color(0.9, 0.5, 0.7),  # spectator 3
	Color(0.6, 0.9, 0.5),  # spectator 4
]

func _ready() -> void:
	status_label.text = "🏃 Running as Wario — press SPACE to disguise!"

func _process(delta: float) -> void:
	if not game_active:
		return
	
	time_left -= delta
	timer_label.text = "%.1f" % time_left
	
	# Distance decreases over time (you're running toward finish)
	distance_to_finish -= delta * 2.0
	
	# Suspicion rises faster when not disguised
	if is_disguised:
		suspicion_level -= delta * 5.0  # Suspicion decays while disguised
		status_label.text = "🎭 Disguised — hold position!"
	else:
		suspicion_level += delta * 3.0  # Suspicion rises when running as Wario
		status_label.text = "🏃 Running as Wario — press SPACE to disguise!"
	
	suspicion_level = clamp(suspicion_level, 0, MAX_SUSPICION)
	
	# Check for capture
	if suspicion_level >= MAX_SUSPICION:
		_end_game(false, "CAPTURED!")
	
	# Check for finish
	if distance_to_finish <= 0:
		_end_game(true, "FINISH!")
	
	# Press SPACE to toggle disguise
	if Input.is_action_just_pressed("sprint"):
		is_disguised = not is_disguised
		if is_disguised:
			score += 10
		else:
			score -= 5
	
	score_label.text = "Score: %d" % score

func _end_game(won: bool, reason: String) -> void:
	game_active = false
	var result_text := "%s — WIN!" % reason if won else "%s — LOSE!" % reason
	var result_color := Color(0.3, 1, 0.3) if won else Color(1, 0.3, 0.3)
	_show_result(result_text, result_color)

func _show_result(text: String, color: Color) -> void:
	var overlay := ColorRect.new()
	overlay.color = color * 0.5
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	add_child(overlay)
	
	var result_label := Label.new()
	result_label.text = text
	result_label.add_theme_font_size_override("font_size", 64)
	result_label.horizontal_alignment = 1
	result_label.position = Vector2(490, 280)
	overlay.add_child(result_label)
	
	var final_score := Label.new()
	final_score.text = "Score: %d" % score
	final_score.add_theme_font_size_override("font_size", 36)
	final_score.horizontal_alignment = 1
	final_score.position = Vector2(490, 380)
	overlay.add_child(final_score)
	
	var retry_btn := Button.new()
	retry_btn.text = "RETRY"
	retry_btn.position = Vector2(540, 480)
	retry_btn.custom_minimum_size = Vector2(100, 50)
	retry_btn.pressed.connect(func(): _retry())
	overlay.add_child(retry_btn)
	
	var menu_btn := Button.new()
	menu_btn.text = "MENU"
	menu_btn.position = Vector2(660, 480)
	menu_btn.custom_minimum_size = Vector2(100, 50)
	menu_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://src/main/microgame_hub.tscn"))
	overlay.add_child(menu_btn)

func _on_start_button_pressed() -> void:
	game_active = true
	time_left = 20.0
	score = 0
	is_disguised = false
	suspicion_level = 0
	distance_to_finish = 100.0
	start_button.visible = false

func _retry() -> void:
	get_tree().reload_current_scene()
