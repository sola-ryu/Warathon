## Core race scene — handles the running, cheats, opponents, and visuals
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

# Visual systems
@onready var screen_shake: Camera2D = $Camera2D
@onready var dam_flash: CanvasLayer = $DAMFlash
@onready var vignette: CanvasLayer = $Vignette
@onready var cheat_zones_node: Node2D = $CheatZones
@onready var spectators_node: Node2D = $Spectators

# Opponents
var opponents := []
var opponent_configs := [
	{"name": "Mario", "personality": 0, "speed_mult": 0.92},
	{"name": "Luigi", "personality": 0, "speed_mult": 0.88},
	{"name": "Peach", "personality": 0, "speed_mult": 0.85},
	{"name": "Toad", "personality": 1, "speed_mult": 0.90},
	{"name": "Yoshi", "personality": 1, "speed_mult": 0.87},
	{"name": "Donkey Kong", "personality": 2, "speed_mult": 0.95},
	{"name": "Bowser", "personality": 3, "speed_mult": 0.93},
]

# Game state
var race_active := false
var current_stage_idx := 0
var stages := ["city", "park", "bowser", "dream", "finish"]
var stage_progress := 0.0
var total_race_distance := 5000.0

# Cheat input
const OPPONENT_SCRIPT: GDScript = preload("res://src/characters/opponent.gd")

const CHEAT_BY_KEY := {
	KEY_A: "Sandwich Snatch",
	KEY_B: "Banana Barrage",
	KEY_C: "Fake Police",
	KEY_D: "Oil Spill",
	KEY_E: "Spectator Wall",
	KEY_F: "Energy Shot",
}

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
	if event is InputEventKey and event.pressed:
		var cheat_name: String = CHEAT_BY_KEY.get(event.keycode)
		if cheat_name != null:
			if CheatManager.execute(cheat_name, wario.current_distance):
				wario.start_cheat_animation()
				
				# Visual juice
				dam_flash.flash_cheat(cheat_name)
				vignette.activate()
				screen_shake.medium_shake()
				
				await get_tree().create_timer(0.5).timeout
				wario.stop_cheat()

func _update_hud() -> void:
	# Position calculation
	var player_dist: float = wario.current_distance
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
		var result: String = opp.react_to_cheat(cheat_name, wario.current_distance)
		if result == "affected":
			opp.speed = opp.BASE_SPEED * opp.base_speed_multiplier * 0.5

func _on_opponent_position(_position: float) -> void:
	pass

func _transition_to_next_stage() -> void:
	current_stage_idx += 1
	var stage_name: String = stages[current_stage_idx]
	CourseGenerator.set_stage(stage_name)
	CourseGenerator.generate_course()
	
	var cfg := CourseGenerator.get_stage_config()
	course_bg.color = cfg["background_color"]
	ground.color = cfg["ground_color"]
	stage_name_label.text = "Stage %d: %s" % [current_stage_idx + 1, stage_name.capitalize()]
	
	# Refuel for new stage
	CheatManager.refill_fuel(20.0)
	
	# Render zones and spectators
	_render_course()

func _render_course() -> void:
	var segments := CourseGenerator.generate_course()
	
	# Render spectator zones
	for seg in segments:
		if seg["type"] == 1:  # Spectator zone
			var count := randi_range(8, 20)
			for i in range(count):
				var spectator := _create_spectator_sprite()
				spectator.position.x = seg["start"] * 2.0 + (i / float(count)) * seg["length"] * 2.0
				spectators_node.add_child(spectator)

func _create_spectator_sprite() -> Control:
	var container := VBoxContainer.new()
	container.custom_minimum_size = Vector2(16, 30)
	
	var head := ColorRect.new()
	head.color = _random_skin_tone()
	head.custom_minimum_size = Vector2(12, 12)
	container.add_child(head)
	
	var body := ColorRect.new()
	body.color = _random_clothing_color()
	body.custom_minimum_size = Vector2(14, 15)
	container.add_child(body)
	
	return container

func _random_skin_tone() -> Color:
	return [Color(0.95, 0.85, 0.7), Color(0.85, 0.7, 0.55), Color(0.75, 0.6, 0.45), Color(0.9, 0.8, 0.65)][randi() % 4]

func _random_clothing_color() -> Color:
	return [Color(0.3, 0.3, 0.8), Color(0.8, 0.2, 0.2), Color(0.2, 0.6, 0.2), Color(0.9, 0.9, 0.3), Color(0.5, 0.2, 0.6)][randi() % 5]

func _create_opponent(config: Dictionary) -> Node2D:
	var opp = OPPONENT_SCRIPT.new()
	opp.opponent_name = config["name"]
	opp.personality = config["personality"]
	opp.base_speed_multiplier = config["speed_mult"]
	opp.position = Vector2(150 + config.get("start_offset", 0), 500)
	return opp

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
