## Microgame: Bridge Builder — assemble a shortcut from random objects
## WarioWare-style rapid assembly puzzle
extends Control

@onready var timer_label: Label = $TimerLabel
@onready var score_label: Label = $ScoreLabel
@onready var progress_bar: TextureProgressBar = $ProgressBar
@onready var start_button: Button = $StartButton

var game_active := false
var time_left := 12.0
var score := 0
var bridge_progress := 0.0
const BRIDGE_LENGTH := 100.0

# Random objects that appear
const OBJECTS := ["🪵", "🧱", "📦", "🛤️", "⚙️", "🔩"]
var current_object := ""
var object_timer := 0.0
const OBJECT_DISPLAY_TIME := 1.2

func _ready() -> void:
	_update_object()
	progress_bar.value = 0

func _update_object() -> void:
	current_object = OBJECTS[randi() % OBJECTS.size()]
	$ObjectLabel.text = current_object

func _process(delta: float) -> void:
	if not game_active:
		return
	
	time_left -= delta
	timer_label.text = "%.1f" % time_left
	
	object_timer += delta
	if object_timer >= OBJECT_DISPLAY_TIME:
		object_timer = 0
		_update_object()
	
	progress_bar.value = (bridge_progress / BRIDGE_LENGTH) * 100
	
	# Press A to grab the current object
	if Input.is_action_just_pressed("cheat_execute"):
		_grab_object()
	
	if bridge_progress >= BRIDGE_LENGTH:
		_end_game(true, "BRIDGE COMPLETE!")
	elif time_left <= 0:
		_end_game(false, "TIME'S UP!")

func _grab_object() -> void:
	if not game_active:
		return
	
	# Success — add to bridge progress
	bridge_progress += BRIDGE_LENGTH / OBJECTS.size()
	score += 25
	score_label.text = "Score: %d" % score
	
	# Flash progress bar green
	progress_bar.modulate = Color(0.3, 1, 0.3)
	await get_tree().create_timer(0.1).timeout
	progress_bar.modulate = Color(1, 1, 1)

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
	time_left = 12.0
	score = 0
	bridge_progress = 0
	object_timer = 0
	start_button.visible = false

func _retry() -> void:
	get_tree().reload_current_scene()
