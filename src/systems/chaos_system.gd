## Chaos system — handles spectator reactions, multiplier decay, and events
extends Node

signal chaos_event(event_name: String, details: Dictionary)

var event_queue := []
var active_events := {}

func _process(delta: float) -> void:
	# Decay chaos multiplier slowly during honest running
	if not CheatManager.get_active_effects().is_empty():
		pass  # Don't decay while cheats are active
	else:
		if GameData.current_chaos_multiplier > 1.0:
			GameData.current_chaos_multiplier = max(1.0, GameData.current_chaos_multiplier - delta * 0.3)

func trigger_random_event() -> void:
	if randf() < 0.02:  # 2% chance per frame
		var events := ["crowd_cheers", "spectator_interrupts", "official_blinks", "random_boost"]
		var event := events[randi() % events.size()]
		chaos_event.emit(event, {"distance": current_distance()})

func handle_spectator_reaction(spectator_count: int) -> void:
	if spectator_count > 20:
		GameData.spectator_fuel = min(GameData.spectator_fuel + spectator_count * 0.3, 100.0)
	elif spectator_count < 5:
		# Boring zone — less fuel
		pass

func get_crowd_excitement() -> float:
	return clamp(GameData.current_chaos_multiplier / 5.0, 0.0, 1.0)
