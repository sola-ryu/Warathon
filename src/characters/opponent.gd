## Opponent base class — all runners inherit from this
extends "res://src/characters/base_runner.gd"

signal reacted_to_cheat(cheat_name: String, reaction: String)

enum Personality { SERIOUS, SUSPICIOUS, FERAL, VIBES }

@export var personality := Personality.SERIOUS
@export var opponent_name: String = "Mario"
@export var base_speed_multiplier := 0.95

# Resistance to different cheat types
var cheat_resistance := {
	"Sandwich Snatch": 0.1,
	"Banana Barrage": 0.3,
	"Fake Police": 0.2,
	"Oil Spill": 0.4,
	"Spectator Wall": 0.5,
	"Energy Shot": 0.0,
	"Shortcut Gate": 0.0,
	"Sweat Slip": 0.2,
}

# Reaction messages for different cheat types
var cheat_reactions := {
	"Sandwich Snatch": ["*sniff sniff* ...is that a sandwich?", "Hey! My lunch!"],
	"Banana Barrage": ["*trips* ...ow.", "I saw that coming and it still happened."],
	"Fake Police": ["Oh thank god, an authority figure!", "*runs faster out of fear*"],
	"Oil Spill": ["What the— *slip* ...really? Here?"],
	"Spectator Wall": ["The crowd's helping me now!?", "A wall? Of people? That's new."],
	"Energy Shot": ["*feels weird energy* ...that's not medical.", "Why do I feel... nothing?"],
	"Shortcut Gate": ["Did he just— no, that can't be legal.", "*sprints after the shortcut*"],
	"Sweat Slip": ["*steps in puddle* ...is that Wario's sweat? That's gross."],
}

func _ready() -> void:
	speed = BASE_SPEED * base_speed_multiplier

func react_to_cheat(cheat_name: String, _distance_traveled: float) -> String:
	var resistance: float = cheat_resistance.get(cheat_name, 0.3)
	var affected: bool = randf() > resistance
	
	if not affected:
		return "resisted"
	
	var reactions: Array = cheat_reactions.get(cheat_name, ["*confused noises*"])
	var reaction: String = reactions[randi() % reactions.size()]
	
	reacted_to_cheat.emit(cheat_name, reaction)
	
	match personality:
		Personality.SERIOUS:
			speed = BASE_SPEED * base_speed_multiplier * 0.6
		Personality.SUSPICIOUS:
			speed = BASE_SPEED * base_speed_multiplier * 0.8
		Personality.FERAL:
			speed = BASE_SPEED * base_speed_multiplier * 1.2  # Gets angry and speeds up!
		Personality.VIBES:
			pass  # Ignores it
	
	return "affected"

func apply_resistance(_duration: float) -> void:
	match personality:
		Personality.FERAL:
			# Feral opponents fight back — temporarily speed up
			speed = BASE_SPEED * base_speed_multiplier * 1.3
		Personality.SUSPICIOUS:
			# Suspicious ones recover faster
			pass
