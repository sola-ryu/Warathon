## Opponent factory — spawns opponent instances with proper config
extends Node

const OPPONENT_SCENES := {
	"Mario": "res://src/characters/opponent_mario.tscn",
	"Luigi": "res://src/characters/opponent_luigi.tscn",
	"Peach": "res://src/characters/opponent_peach.tscn",
	"Toad": "res://src/characters/opponent_toad.tscn",
	"Yoshi": "res://src/characters/opponent_yoshi.tscn",
	"Donkey Kong": "res://src/characters/opponent_dk.tscn",
	"Bowser": "res://src/characters/opponent_bowser.tscn",
	"Waluigi": "res://src/characters/opponent_waluigi.tscn",
}

const OPPONENT_DEFS := {
	"Mario": {"personality": 0, "speed_mult": 0.92, "start_offset": -50},
	"Luigi": {"personality": 0, "speed_mult": 0.88, "start_offset": -30},
	"Peach": {"personality": 0, "speed_mult": 0.85, "start_offset": -70},
	"Toad": {"personality": 1, "speed_mult": 0.90, "start_offset": -40},
	"Yoshi": {"personality": 1, "speed_mult": 0.87, "start_offset": -60},
	"Donkey Kong": {"personality": 2, "speed_mult": 0.95, "start_offset": -20},
	"Bowser": {"personality": 3, "speed_mult": 0.93, "start_offset": -80},
	"Waluigi": {"personality": 3, "speed_mult": 0.91, "start_offset": -45},
}

func spawn_opponent(name: String, start_x: float, start_y: float) -> Node2D:
	var def := OPPONENT_DEFS.get(name)
	if def == null:
		return null
	
	var scene_path := OPPONENT_SCENES.get(name)
	if scene_path == null:
		return null
	
	var scene = load(scene_path)
	if scene == null:
		return null
	
	var instance = scene.instantiate()
	instance.opponent_name = name
	instance.personality = def["personality"]
	instance.base_speed_multiplier = def["speed_mult"]
	instance.position = Vector2(start_x, start_y)
	
	return instance

func spawn_default_lineup(start_x: float, start_y: float) -> Array[Node2D]:
	var lineup := []
	for name in ["Mario", "Luigi", "Peach", "Toad", "Yoshi", "Donkey Kong", "Bowser"]:
		var def := OPPONENT_DEFS[name]
		var opp = spawn_opponent(name, start_x + def["start_offset"], start_y)
		if opp:
			lineup.append(opp)
	return lineup

func spawn_waluigi_rival(start_x: float, start_y: float) -> Node2D:
	return spawn_opponent("Waluigi", start_x - 45, start_y)
