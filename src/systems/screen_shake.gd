## Screen shake effect for cheat execution and chaos moments
extends Camera2D

@onready var original_position := position

var shake_intensity := 0.0
var shake_duration := 0.0
var shake_elapsed := 0.0

func _process(delta: float) -> void:
	if shake_duration > 0:
		shake_elapsed += delta
		var progress := shake_elapsed / shake_duration
		
		if progress < 1.0:
			# Exponential decay shake
			var intensity := shake_intensity * (1.0 - progress) * (1.0 - progress)
			position.x = original_position.x + randf_range(-intensity, intensity)
			position.y = original_position.y + randf_range(-intensity, intensity)
		else:
			position = original_position
			shake_duration = 0.0
			shake_elapsed = 0.0

func shake(intensity: float, duration: float) -> void:
	shake_intensity = intensity
	shake_duration = duration
	shake_elapsed = 0.0

func big_shake() -> void:
	shake(15.0, 0.4)

func medium_shake() -> void:
	shake(8.0, 0.3)

func small_shake() -> void:
	shake(4.0, 0.2)
