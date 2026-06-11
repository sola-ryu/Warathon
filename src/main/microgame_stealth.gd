## Microgame: Stealth Sandwich — grab food without being seen
## WarioWare-style timed mini-game
extends Control

@onready var timer_label: Label = $TimerLabel
@onready var score_label: Label = $ScoreLabel
@onready var sandwich_target: ColorRect = $FoodZone/SandwichTarget
@onready var guard_label: Label = $GuardLabel
@onready var start_button: Button = $StartButton

var game_active := false
var time_left := 10.0
var score := 0
var guard_awareness := 0.0
var guard_direction := 1  # 1 = looking right, -1 = looking left
var sandwich_eaten := false

const GUARD_SPEED := 0.8
const GUARD_REACTION_TIME := 3.0  # seconds before guard notices

func _ready() -> void:
	score_label.text = "Score: 0"
	guard_label.text = "👀 Guard looking right"

func _process(delta: float) -> void:
	if not game_active:
		return
	
	time_left -= delta
	timer_label.text = "%.1f" % time_left
	
	# Guard patrols back and forth
	guard_awareness += delta * GUARD_SPEED
	if guard_awareness > GUARD_REACTION_TIME:
		guard_direction *= -1
		guard_awareness = 0.0
		guard_label.text = "👀 Guard looking %s" % ("left" if guard_direction < 0 else "right")
	
	# Check if sandwich can be grabbed
	if not sandwich_eaten and Input.is_action_just_pressed("cheat_execute"):
		_attempt_grab()

func _attempt_grab() -> void:
	if guard_direction > 0:
		# Guard looking away — success!
		score += 100
		sandwich_eaten = true
		sandwich_target.visible = false
		score_label.text = "Score: %d" % score
	else:
		# Guard sees you — penalty!
		score = max(0, score - 50)
		score_label.text = "Score: %d" % score
		# Flash red briefly
		$FoodZone.modulate = Color(1, 0.3, 0.3)
		await get_tree().create_timer(0.2).timeout
		$FoodZone.modulate = Color(1, 1, 1)

func _on_start_button_pressed() -> void:
	game_active = true
	time_left = 10.0
	score = 0
	sandwich_eaten = false
	start_button.visible = false
	sandwich_target.visible = true
	score_label.text = "Score: 0"

func _check_win() -> void:
	if sandwich_eaten and time_left > 0:
		# Win! Bonus for time remaining
		score += int(time_left * 20)
		_show_result(true)
	elif time_left <= 0:
		_show_result(false)

func _show_result(won: bool) -> void:
	game_active = false
	var result_text := "WIN!" if won else "LOSE!"
	var result_color := Color(0.3, 1, 0.3) if won else Color(1, 0.3, 0.3)
	
	# Show result overlay
	var overlay := ColorRect.new()
	overlay.color = result_color * 0.5
	overlay.anchors_preset = 15
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	add_child(overlay)
	
	var result_label := Label.new()
	result_label.text = result_text
	result_label.add_theme_font_size_override("font_size", 72)
	result_label.horizontal_alignment = 1
	result_label.position = Vector2(490, 280)
	overlay.add_child(result_label)
	
	var final_score := Label.new()
	final_score.text = "Score: %d" % score
	final_score.add_theme_font_size_override("font_size", 36)
	final_score.horizontal_alignment = 1
	final_score.position = Vector2(490, 400)
	overlay.add_child(final_score)
	
	var retry_btn := Button.new()
	retry_btn.text = "RETRY"
	retry_btn.position = Vector2(540, 500)
	retry_btn.custom_minimum_size = Vector2(100, 50)
	retry_btn.pressed.connect(func(): _retry())
	overlay.add_child(retry_btn)
	
	var menu_btn := Button.new()
	menu_btn.text = "MENU"
	menu_btn.position = Vector2(660, 500)
	menu_btn.custom_minimum_size = Vector2(100, 50)
	menu_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://src/main/microgame_hub.tscn"))
	overlay.add_child(menu_btn)

func _retry() -> void:
	get_tree().reload_current_scene()
