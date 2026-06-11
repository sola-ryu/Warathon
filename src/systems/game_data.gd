## Global game state — persists across races
extends Node

signal score_updated(new_score)
signal chaos_multiplier_updated(multiplier)

# Player stats
var total_score := 0.0
var current_chaos_multiplier := 1.0
var honesty_rating := 0.0
var gold_coins := 0

# Unlocked cheats (by name)
var unlocked_cheats := ["Sandwich Snatch", "Banana Barrage", "Oil Spill"]

# Spectator fuel (0-100%)
var spectator_fuel := 50.0

# Current stage
var current_stage := ""

# Cheat codex — tracks every cheat used in a race
var cheat_log := []

func add_score(points: float) -> void:
	total_score += points * current_chaos_multiplier
	score_updated.emit(total_score)

func increment_chaos() -> void:
	current_chaos_multiplier = min(current_chaos_multiplier + 0.5, 10.0)
	chaos_multiplier_updated.emit(current_chaos_multiplier)

func reset_chaos() -> void:
	current_chaos_multiplier = 1.0
	chaos_multiplier_updated.emit(1.0)

func log_cheat(cheat_name: String, success: bool, distance: float) -> void:
	cheat_log.append({
		"cheat": cheat_name,
		"success": success,
		"distance_meters": distance,
		"time": Time.get_ticks_msec()
	})

func reset_for_race() -> void:
	total_score = 0.0
	current_chaos_multiplier = 1.0
	honesty_rating = 0.0
	spectator_fuel = 50.0
	cheat_log.clear()
	score_updated.emit(0)
	chaos_multiplier_updated.emit(1.0)
