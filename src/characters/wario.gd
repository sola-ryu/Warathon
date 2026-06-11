## Wario — the player character
extends "res://src/characters/base_runner.gd"

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum State { RUNNING, CHEATING, BOOSTING, SLIDING }
var state := State.RUNNING

func _process(delta: float) -> void:
	super._process(delta)
	
	match state:
		State.CHEATING:
			# Wario's cheating animation
			if sprite:
				sprite.frame = 1
		State.BOOSTING:
			if sprite:
				sprite.frame = 2
		State.SLIDING:
			if sprite:
				sprite.frame = 3

func start_cheat_animation() -> void:
	state = State.CHEATING

func activate_boost(duration: float) -> void:
	state = State.BOOSTING
	apply_cheat_boost(duration, 1.5)

func activate_slip(_duration: float) -> void:
	state = State.SLIDING
	speed = BASE_SPEED * 0.3

func stop_cheat() -> void:
	state = State.RUNNING
