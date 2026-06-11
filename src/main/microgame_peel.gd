## Microgame: Peel Master — place banana peels on specific runners
## WarioWare-style rapid-fire timing game
extends Control

@onready var timer_label: Label = $TimerLabel
@onready var score_label: Label = $ScoreLabel
@onready var target_label: Label = $TargetLabel
@onready var peel_zone: ColorRect = $PeelZone
@onready var start_button: Button = $StartButton

var game_active := false
var time_left := 15.0
var score := 0
var current_target := ""
var targets_remaining := 0
const TOTAL_TARGETS := 5

const OPPONENT_COLORS := {
	"Mario": Color(1, 0.2, 0.2),
	"Luigi": Color(0.2, 0.7, 0.2),
	"Peach": Color(1, 0.6, 0.8),
	"Toad": Color(1, 0.9, 0.3),
	"Yoshi": Color(0.3, 0.9, 0.3),
	"DK": Color(0.5, 0.3, 0.1),
	"Bowser": Color(0.8, 0.2, 0.1),
}

const OPPONENT_NAMES := ["Mario", "Luigi", "Peach", "Toad", "Yoshi", "DK", "Bowser"]

func _ready() -> void:
	_update_target()

func _update_target() -> void:
	if targets_remaining <= 0:
		return
	
	var name: String = OPPONENT_NAMES[randi() % OPPONENT_NAMES.size()]
	current_target = name
	target_label.text = "🍌 Peel for: %s!" % name
	target_label.add_theme_color_override("font_color", OPPONENT_COLORS[name])

func _process(delta: float) -> void:
	if not game_active:
		return
	
	time_left -= delta
	timer_label.text = "%.1f" % time_left
	
	if time_left <= 0:
		_end_game()
	
	# Press A to place peel on current target
	if Input.is_action_just_pressed("cheat_execute"):
		_place_peel()

func _place_peel() -> void:
	if not game_active:
		return
	
	if current_target != "":
		score += 50
		targets_remaining -= 1
		
		# Flash peel zone
		var flash_color: Color = OPPONENT_COLORS[current_target]
		peel_zone.color = flash_color * 0.8
		await get_tree().create_timer(0.15).timeout
		peel_zone.color = Color(0.9, 0.9, 0.3)
		
		score_label.text = "Score: %d" % score
		
		if targets_remaining <= 0:
			_end_game(false)
		else:
			_update_target()

func _end_game(forced: bool = false) -> void:
	game_active = false
	
	var won := not forced and targets_remaining <= 0
	var result_text := "WIN!" if won else "LOSE!"
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

func _on_start_button_pressed() -> void:
	game_active = true
	time_left = 15.0
	score = 0
	targets_remaining = TOTAL_TARGETS
	start_button.visible = false
	_update_target()

func _retry() -> void:
	get_tree().reload_current_scene()
