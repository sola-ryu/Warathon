## Base character — Wario or opponent
extends CharacterBody2D

signal position_changed(new_position: float)

const BASE_SPEED := 200.0
const BOOST_MULTIPLIER := 1.5

var speed := BASE_SPEED
var is_cheating := false
var cheat_boost_timer := 0.0
var current_distance := 0.0

@export var character_name: String = "Wario"
@export var is_player := false

func _process(delta: float) -> void:
	# Auto-run forward (right)
	var effective_speed := speed
	if cheat_boost_timer > 0:
		effective_speed *= BOOST_MULTIPLIER
		cheat_boost_timer -= delta
	
	velocity.x = effective_speed
	move_and_slide()
	
	current_distance += effective_speed * delta
	position_changed.emit(current_distance)

func apply_cheat_boost(duration: float, multiplier: float) -> void:
	speed = BASE_SPEED * multiplier
	cheat_boost_timer = duration

func reset() -> void:
	speed = BASE_SPEED
	cheat_boost_timer = 0.0
	current_distance = 0.0
	is_cheating = false
