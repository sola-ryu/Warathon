## Manages cheat cooldowns, execution, and effects
extends Node

signal cheat_executed(cheat_name: String, success: bool)
signal cheat_cooldown_changed(cheat_name: String, remaining: float)

# Cheat definitions
const CHEAT_DEFS := {
	"Sandwich Snatch": {
		"cooldown": 3.0,
		"fuel_cost": 10,
		"effect_duration": 5.0,
		"boost_amount": 1.5,
	},
	"Banana Barrage": {
		"cooldown": 5.0,
		"fuel_cost": 15,
		"peel_count": 3,
		"slide_duration": 2.0,
	},
	"Fake Police": {
		"cooldown": 8.0,
		"fuel_cost": 20,
		"slow_amount": 0.4,
		"duration": 4.0,
	},
	"Oil Spill": {
		"cooldown": 4.0,
		"fuel_cost": 12,
		"slide_duration": 3.0,
	},
	"Spectator Wall": {
		"cooldown": 6.0,
		"fuel_cost": 18,
		"block_duration": 3.0,
	},
	"Energy Shot": {
		"cooldown": 10.0,
		"fuel_cost": 25,
		"burst_amount": 2.5,
		"duration": 2.0,
	},
	"Shortcut Gate": {
		"cooldown": 15.0,
		"fuel_cost": 30,
		"distance_saved": 100.0,
	},
	"Sweat Slip": {
		"cooldown": 3.5,
		"fuel_cost": 8,
		"slide_duration": 1.5,
	},
}

# Active cheat states: { cheat_name: { "on_cooldown": bool, "timer": float, "active": bool, "end_timer": float } }
var active_cheats := {}
var fuel_available := 50.0

func _ready() -> void:
	for cheat_name in CHEAT_DEFS:
		active_cheats[cheat_name] = {
			"on_cooldown": false,
			"timer": 0.0,
			"active": false,
			"end_timer": 0.0,
		}

func _process(delta: float) -> void:
	for cheat_name in active_cheats:
		var state: Dictionary = active_cheats[cheat_name]
		if state["on_cooldown"]:
			state["timer"] -= delta
			if state["timer"] <= 0:
				state["on_cooldown"] = false
				state["timer"] = 0.0
				cheat_cooldown_changed.emit(cheat_name, 0.0)
		if state["active"]:
			state["end_timer"] -= delta
			if state["end_timer"] <= 0:
				state["active"] = false
				state["end_timer"] = 0.0

func can_execute(cheat_name: String) -> bool:
	if not CHEAT_DEFS.has(cheat_name):
		return false
	var state: Dictionary = active_cheats[cheat_name]
	return not state["on_cooldown"] and GameData.unlocked_cheats.has(cheat_name)

func execute(cheat_name: String, distance_traveled: float = 0.0) -> bool:
	if not can_execute(cheat_name):
		return false
	
	var def: Dictionary = CHEAT_DEFS[cheat_name]
	var cost: int = def["fuel_cost"]
	
	if fuel_available < cost:
		return false
	
	fuel_available -= cost
	GameData.spectator_fuel = max(0, GameData.spectator_fuel - cost * 0.5)
	
	var state: Dictionary = active_cheats[cheat_name]
	state["on_cooldown"] = true
	state["timer"] = def["cooldown"]
	
	if "effect_duration" in def or "duration" in def:
		state["active"] = true
		state["end_timer"] = def.get("effect_duration", def.get("duration", 0.0))
	
	GameData.log_cheat(cheat_name, true, distance_traveled)
	GameData.increment_chaos()
	GameData.add_score(def.get("boost_amount", 1.0) * 100)
	
	cheat_executed.emit(cheat_name, true)
	
	# Check for unlocks
	if GameData.total_score > 500 and not GameData.unlocked_cheats.has("Energy Shot"):
		GameData.unlocked_cheats.append("Energy Shot")
	elif GameData.total_score > 1500 and not GameData.unlocked_cheats.has("Shortcut Gate"):
		GameData.unlocked_cheats.append("Shortcut Gate")
	
	return true

func get_cooldown_remaining(cheat_name: String) -> float:
	if not active_cheats.has(cheat_name):
		return 0.0
	var state: Dictionary = active_cheats[cheat_name]
	return state["timer"] if state["on_cooldown"] else 0.0

func get_active_effects() -> Array:
	var effects := []
	for cheat_name in active_cheats:
		if active_cheats[cheat_name]["active"]:
			effects.append(cheat_name)
	return effects

func refill_fuel(amount: float) -> void:
	fuel_available = min(fuel_available + amount, 100.0)
	GameData.spectator_fuel = min(GameData.spectator_fuel + amount * 2, 100.0)
