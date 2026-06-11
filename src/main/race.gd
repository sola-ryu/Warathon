## Core race scene — handles the running, cheats, opponents, and visuals
extends Node2D

const PIXELS_PER_UNIT := 2.0
const SCREEN_W := 1280
const SCREEN_H := 720
const GROUND_H := 200

enum SegmentType { ROAD, SPECTATOR_ZONE, FOOD_VENDOR, WATER_STATION, MEDICAL_TENT, BRIDGE, SHORTCUT, OBSTACLE }

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
var course_segments := []
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
	Key.KEY_A: "Sandwich Snatch",
	Key.KEY_B: "Banana Barrage",
	Key.KEY_C: "Fake Police",
	Key.KEY_D: "Oil Spill",
	Key.KEY_E: "Spectator Wall",
	Key.KEY_F: "Energy Shot",
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
	
	# Auto-start the race
	start_race()

func _process(delta: float) -> void:
	if not race_active:
		return
	
	camera_2d.position.x = wario.current_distance - 300
	
	var cam_x: float = camera_2d.position.x
	var cam_y: float = camera_2d.position.y
	course_bg.position = Vector2(cam_x - SCREEN_W / 2.0, cam_y - SCREEN_H / 2.0)
	ground.position = Vector2(cam_x - SCREEN_W / 2.0, cam_y + SCREEN_H / 2.0 - GROUND_H)
	
	_update_hud()
	
	stage_progress += wario.speed * delta
	var stage_length := total_race_distance / 5.0
	
	if stage_progress >= stage_length and current_stage_idx < stages.size() - 1:
		_transition_to_next_stage()

func _input(event: InputEvent) -> void:
	if not race_active:
		return
	
	# Cheat execution via keyboard shortcuts
	if event is InputEventKey and event.pressed:
		var kc: Key = event.keycode
		if CHEAT_BY_KEY.has(kc):
			var cheat_name: String = CHEAT_BY_KEY[kc]
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
	
	var player_pos := 1
	for i in range(positions.size()):
		if positions[i]["name"] == "Wario":
			player_pos = i + 1
			break
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
	
	# Let opponents react to the cheat (they handle their own speed adjustments)
	for opp in opponents:
		opp.react_to_cheat(cheat_name, wario.current_distance)

func _on_opponent_position(_position: float) -> void:
	pass

func _transition_to_next_stage() -> void:
	current_stage_idx += 1
	var stage_name: String = stages[current_stage_idx]
	CourseGenerator.set_stage(stage_name)
	course_segments = CourseGenerator.generate_course()
	
	var cfg := CourseGenerator.get_stage_config()
	course_bg.set_anchors_preset(Control.PRESET_TOP_LEFT)
	course_bg.color = cfg["background_color"]
	course_bg.set_deferred("size", Vector2(SCREEN_W, SCREEN_H))
	ground.set_anchors_preset(Control.PRESET_TOP_LEFT)
	ground.color = cfg["ground_color"]
	ground.set_deferred("size", Vector2(SCREEN_W, GROUND_H))
	stage_name_label.text = "Stage %d: %s" % [current_stage_idx + 1, stage_name.capitalize()]
	
	CheatManager.refill_fuel(20.0)
	
	_render_course()

func _render_course() -> void:
	for child in spectators_node.get_children():
		child.queue_free()
	
	for seg in course_segments:
		var seg_type: int = seg["type"]
		var sx: float = seg["start"] * PIXELS_PER_UNIT
		var sw: float = seg["length"] * PIXELS_PER_UNIT
		var ground_top: float = SCREEN_H / 2.0 - GROUND_H
		
		match seg_type:
			SegmentType.SPECTATOR_ZONE:
				_render_spectator_zone(seg, sx, sw)
			SegmentType.FOOD_VENDOR:
				_render_vendor(sx, sw, ground_top, Color(1, 0.85, 0.2), "FOOD")
			SegmentType.WATER_STATION:
				_render_vendor(sx, sw, ground_top, Color(0.3, 0.6, 1), "WATER")
			SegmentType.MEDICAL_TENT:
				_render_medical_tent(sx, sw, ground_top)
			SegmentType.BRIDGE:
				_render_bridge(sx, sw, ground_top)
			SegmentType.SHORTCUT:
				_render_shortcut(sx, sw, ground_top)
			SegmentType.OBSTACLE:
				_render_obstacle(sx, sw, ground_top)

func _render_spectator_zone(_seg: Dictionary, sx: float, sw: float) -> void:
	var count := randi_range(6, 14)
	for i in range(count):
		var box := ColorRect.new()
		box.size = Vector2(10, 16)
		box.color = Color(randf_range(0.5, 1), randf_range(0.5, 1), randf_range(0.5, 1))
		box.position = Vector2(sx + (i / float(count)) * sw, SCREEN_H / 2.0 - GROUND_H - 18 + randi_range(-2, 2))
		spectators_node.add_child(box)

func _render_vendor(sx: float, sw: float, ground_top: float, color: Color, label: String) -> void:
	var rect := ColorRect.new()
	rect.size = Vector2(sw, GROUND_H * 0.6)
	rect.color = color
	rect.position = Vector2(sx, ground_top - rect.size.y)
	spectators_node.add_child(rect)
	
	var lbl := Label.new()
	lbl.text = label
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.position = Vector2(sx, ground_top - rect.size.y)
	lbl.size = Vector2(sw, rect.size.y)
	spectators_node.add_child(lbl)

func _render_medical_tent(sx: float, sw: float, ground_top: float) -> void:
	var rect := ColorRect.new()
	rect.size = Vector2(sw, GROUND_H * 0.6)
	rect.color = Color(0.9, 0.9, 0.9)
	rect.position = Vector2(sx, ground_top - rect.size.y)
	spectators_node.add_child(rect)
	
	var cross := ColorRect.new()
	cross.size = Vector2(sw * 0.3, GROUND_H * 0.3)
	cross.color = Color(0.9, 0.2, 0.2)
	cross.position = Vector2(sx + sw * 0.35, ground_top - rect.size.y + rect.size.y * 0.2)
	spectators_node.add_child(cross)
	
	# Cross vertical bar
	var cross_v := ColorRect.new()
	cross_v.size = Vector2(GROUND_H * 0.15, GROUND_H * 0.3)
	cross_v.color = Color(0.9, 0.2, 0.2)
	cross_v.position = Vector2(sx + sw / 2.0 - cross_v.size.x / 2.0, ground_top - rect.size.y + rect.size.y * 0.2)
	spectators_node.add_child(cross_v)

func _render_bridge(sx: float, sw: float, ground_top: float) -> void:
	var platform := ColorRect.new()
	platform.size = Vector2(sw, 12)
	platform.color = Color(0.5, 0.35, 0.2)
	platform.position = Vector2(sx, ground_top)
	spectators_node.add_child(platform)
	
	for i in range(int(sw / 20)):
		var post := ColorRect.new()
		post.size = Vector2(4, 20)
		post.color = Color(0.4, 0.25, 0.15)
		post.position = Vector2(sx + i * 20.0, ground_top - 20)
		spectators_node.add_child(post)

func _render_shortcut(sx: float, sw: float, ground_top: float) -> void:
	var arrow := ColorRect.new()
	arrow.size = Vector2(sw, 20)
	arrow.color = Color(0.2, 0.8, 0.2)
	arrow.position = Vector2(sx, ground_top - 30)
	spectators_node.add_child(arrow)
	
	var lbl := Label.new()
	lbl.text = ">> SHORTCUT >>"
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.position = Vector2(sx, ground_top - 50)
	lbl.size = Vector2(sw, 20)
	spectators_node.add_child(lbl)

func _render_obstacle(sx: float, sw: float, ground_top: float) -> void:
	var hazard := ColorRect.new()
	hazard.size = Vector2(sw, GROUND_H * 0.5)
	hazard.color = Color(0.8, 0.1, 0.1)
	hazard.position = Vector2(sx, ground_top - hazard.size.y)
	spectators_node.add_child(hazard)
	
	for i in range(int(sw / 30)):
		var stripe := ColorRect.new()
		stripe.size = Vector2(14, GROUND_H * 0.5)
		stripe.color = Color(1, 0.6, 0)
		stripe.position = Vector2(sx + 2 + i * 30.0, ground_top - hazard.size.y)
		spectators_node.add_child(stripe)

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
	course_segments = CourseGenerator.generate_course()
	
	var cfg := CourseGenerator.get_stage_config()
	course_bg.set_anchors_preset(Control.PRESET_TOP_LEFT)
	course_bg.color = cfg["background_color"]
	course_bg.set_deferred("size", Vector2(SCREEN_W, SCREEN_H))
	ground.set_anchors_preset(Control.PRESET_TOP_LEFT)
	ground.color = cfg["ground_color"]
	ground.set_deferred("size", Vector2(SCREEN_W, GROUND_H))
	stage_name_label.text = "Stage 1: City"
	
	wario.reset()
	for opp in opponents:
		opp.reset()
	
	_render_course()

func end_race() -> void:
	race_active = false
	get_tree().change_scene_to_file("res://src/main/results.tscn")
