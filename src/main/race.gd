## Core race scene — handles the running, cheats, and opponent logic
extends Node2D

@onready var wario: CharacterBody2D = $Wario
@onready var camera_2d: Camera2D = $Camera2D
@onready var course_bg: ColorRect = $Background
@onready var ground: ColorRect = $Ground
@onready var cheat_ui: Control = $CheatUI
@onready var position_display: Label = $HUD/PositionDisplay
@onready var score_label: Label = $HUD/ScoreLabel
@onready var fuel_bar: TextureProgressBar = $HUD/FuelBar
@onready var chaos_label: Label = $HUD/ChaosLabel
@onready var cheat_icons: HBoxContainer = $CheatUI/CheatIcons
@onready var stage_name_label: Label = $HUD/StageName

# Opponents
var opponents := []
var opponent_configs := [
	{"name": "Mario", "personality": 0, "speed_mult": 0.92},
	{"name": "Luigi", "personality": 0, "speed_mult": 0.88},
	{"name": "Peach", "personality": 0, "speed_mult": 0.85},
	{"name": "Toad", "personality": 1, "speed_mult": 0.90},
	{"name": "Yoshi", "personality": 1, "speed_mult": 0.87},
	{"name": "DK", "personality": 2, "speed_mult": 0.95},
	{"name": "Bowser", "personality": 3, "speed_mult": 0.93},
]

# Game state
var race_active := false
var current_stage_idx := 0
var stages := ["city", "park", "bowser", "dream", "finish"]
var stage_progress := 0.0
var total_race_distance := 5000.0

# Cheat input
var cheat_input_buffer := ""
const CHEAT_KEYS := {"A": "Sandwich Snatch", "B": "Banana Barrage", "C": "Fake Police", 
	"D": "Oil Spill", "E": "Spectator Wall", "F": "Energy Shot"}

func _ready() -> void:
	GameData.score_updated.connect(_on_score_updated)
	GameData.chaos_multiplier_updated.connect(_on_chaos_updated)
	CheatManager.cheat_executed.connect(_on_cheat_executed)
	
	# Create opponents
	for config in opponent_configs:
		var opp = _create_opponent(config)
		opponents.append(opp)
		add_child(opp)
		opp.position_changed.connect(_on_opponent_position)

func _process(delta: float) -> void:
	if not race_active:
		return
	
	# Update camera to follow Wario
	camera_2d.position.x = wario.current_distance - 300
	
	# Update HUD
	_update_hud()
	
	# Check stage transitions
	stage_progress += wario.speed * delta
	var stage_length := total_race_distance / 5.0
	
	if stage_progress >= stage_length and current_stage_idx < stages.size() - 1:
		_transition_to_next_stage()

func _input(event: InputEvent) -> void:
	if not race_active:
		return
	
	# Cheat execution via keyboard shortcuts
	for key in CHEAT_KEYS:
		if event is InputEventKey and event.pressed and event.keycode == key.to_lower().ord_at(0):
			var cheat_name := CHEAT_KEYS[key]
			if CheatManager.execute(cheat_name, wario.current_distance):
				wario.start_cheat_animation()
				await get_tree().create_timer(0.5).timeout
				wario.stop_cheat()

func _update_hud() -> void:
	# Position calculation
	var player_dist := wario.current_distance
	var positions := [{"name": "Wario", "dist": player_dist}]
	for opp in opponents:
		positions.append({"name": opp.opponent_name, "dist": opp.current_distance})
	positions.sort_custom(func(a, b): return a["dist"] > b["dist"])
	
	var player_pos := positions.find({"name": "Wario"}) + 1
	position_display.text = "%dth Place (Obviously)" % player_pos
	
	score_label.text = "Score: %d" % int(GameData.total_score)
	fuel_bar.value = GameData.spectator_fuel
	chaos_label.text = "Chaos: x%.1f" % GameData.current_chaos_multiplier

func _on_score_updated(new_score: float) -> void:
	score_label.text = "Score: %d" % int(new_score)

func _on_chaos_updated(multiplier: float) -> void:
	chaos_label.text = "Chaos: x%.1f" % multiplier

func _on_cheat_executed(cheat_name: String, success: bool) -> void:
	if not success:
		return
	
	# Apply cheat effects to opponents
	for opp in opponents:
		var result := opp.react_to_cheat(cheat_name, wario.current_distance)
		if result == "affected":
			opp.speed = opp.BASE_SPEED * opp.base_speed_multiplier * 0.5
			await get_tree().create_timer(2.0).timeout
			opp.speed = opp.BASE_SPEED * opp.base_speed_multiplier

func _on_opponent_position(position: float) -> void:
	pass  # Could trigger events based on opponent positions

func _transition_to_next_stage() -> void:
	current_stage_idx += 1
	var stage_name := stages[current_stage_idx]
	CourseGenerator.set_stage(stage_name)
	CourseGenerator.generate_course()
	
	var cfg := CourseGenerator.get_stage_config()
	course_bg.color = cfg["background_color"]
	ground.color = cfg["ground_color"]
	stage_name_label.text = "Stage %d: %s" % (current_stage_idx + 1, stage_name.capitalize())
	
	# Refuel for new stage
	CheatManager.refill_fuel(20.0)

func start_race() -> void:
	race_active = true
	GameData.reset_for_race()
	current_stage_idx = 0
	stage_progress = 0.0
	
	CourseGenerator.set_stage("city")
	CourseGenerator.generate_course()
	
	var cfg := CourseGenerator.get_stage_config()
	course_bg.color = cfg["background_color"]
	ground.color = cfg["ground_color"]
	stage_name_label.text = "Stage 1: City"
	
	wario.reset()
	for opp in opponents:
		opp.reset()

func end_race() -> void:
	race_active = false
	get_tree().change_scene_to_file("res://src/main/results.tscn")
