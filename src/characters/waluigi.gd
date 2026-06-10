## Waluigi rival — special opponent with cheat ability
## In Retrathon mode, Waluigi also cheats and tries to beat Wario
extends "res://src/characters/opponent.gd"

signal waluligi_cheat_executed(cheat_name: String)

# Waluigi has his own cheat set
@export var rival_cheats := ["Sandwich Snatch", "Banana Barrage", "Energy Shot"]
@export var cheat_aggression := 0.3  # Probability per frame to cheat

# Rival-specific reactions (more confrontational)
var rival_reactions := {
	"Sandwich Snatch": ["*snatches it back* 'MINE!'", "You think that's yours? *stomps*"],
	"Banana Barrage": ["*slips, recovers, gets mad*", "I will END you, Wario!"],
	"Energy Shot": ["*feels the energy* ...nice. *takes it*", "That power is MINE now!"],
}

func react_to_cheat(cheat_name: String, distance_traveled: float) -> String:
	var resistance := cheat_resistance.get(cheat_name, 0.2)  # Lower = more affected
	var affected := randf() > resistance
	
	if not affected:
		return "resisted"
	
	var reactions := rival_reactions.get(cheat_name, ["*glaring*", "*runs faster in anger*"])
	var reaction := reactions[randi() % reactions.size()]
	
	reacted_to_cheat.emit(cheat_name, reaction)
	
	# Feral: gets angry and speeds up (fight back!)
	speed = BASE_SPEED * base_speed_multiplier * 1.3
	
	return "affected"

func _process(delta: float) -> void:
	# Waluigi has a chance to execute his own cheats
	if randf() < cheat_aggression * delta:
		_execute_rival_cheat()

func _execute_rival_cheat() -> void:
	var cheat := rival_cheats[randi() % rival_cheits.size()]
	waluligi_cheat_executed.emit(cheat)
	
	# Apply effect: Waluigi gets a speed boost
	speed = BASE_SPEED * base_speed_multiplier * 1.5
	await get_tree().create_timer(2.0).timeout
	speed = BASE_SPEED * base_speed_multiplier
