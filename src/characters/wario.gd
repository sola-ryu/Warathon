## Wario — the player character
extends "res://src/characters/base_runner.gd"

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum State { RUNNING, CHEATING, BOOSTING, SLIDING }
var state := State.RUNNING

const RUN_TEXTURE := preload("res://assets/sprites/wario_run.png")

func _process(delta: float) -> void:
	super._process(delta)

func start_cheat_animation() -> void:
	state = State.CHEATING
	sprite.texture = RUN_TEXTURE
	sprite.modulate = Color(0.7, 1, 0.7)

func activate_boost(duration: float) -> void:
	state = State.BOOSTING
	apply_cheat_boost(duration, 1.5)
	sprite.texture = RUN_TEXTURE
	sprite.modulate = Color(1, 1, 0.6)

func activate_slip(_duration: float) -> void:
	state = State.SLIDING
	speed = BASE_SPEED * 0.3
	sprite.texture = RUN_TEXTURE
	sprite.modulate = Color(0.6, 0.8, 1)

func stop_cheat() -> void:
	state = State.RUNNING
	sprite.texture = RUN_TEXTURE
	sprite.modulate = Color.WHITE
