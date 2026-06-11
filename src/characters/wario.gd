## Wario — the player character
extends "res://src/characters/base_runner.gd"

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum State { RUNNING, CHEATING, BOOSTING, SLIDING }
var state := State.RUNNING

const SPRITES := {
	"standing": preload("res://assets/sprites/wario_standing.png"),
	"cheating": preload("res://assets/sprites/wario_cheating.png"),
	"boosting": preload("res://assets/sprites/wario_boosting.png"),
	"slipping": preload("res://assets/sprites/wario_slipping.png"),
}

func _process(delta: float) -> void:
	super._process(delta)

func start_cheat_animation() -> void:
	state = State.CHEATING
	if sprite and SPRITES.has("cheating"):
		sprite.texture = SPRITES["cheating"]

func activate_boost(duration: float) -> void:
	state = State.BOOSTING
	apply_cheat_boost(duration, 1.5)
	if sprite and SPRITES.has("boosting"):
		sprite.texture = SPRITES["boosting"]

func activate_slip(_duration: float) -> void:
	state = State.SLIDING
	speed = BASE_SPEED * 0.3
	if sprite and SPRITES.has("slipping"):
		sprite.texture = SPRITES["slipping"]

func stop_cheat() -> void:
	state = State.RUNNING
	if sprite and SPRITES.has("standing"):
		sprite.texture = SPRITES["standing"]
