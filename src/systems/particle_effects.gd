## Particle effects for cheat execution — banana peels, oil splashes, sweat drops
extends Node2D

@onready var particles_node := $Particles

func _ready() -> void:
	pass

func spawn_cheat_effects(cheat_name: String, position: Vector2) -> void:
	match cheat_name:
		"Sandwich Snatch":
			_spawn_food_particles(position)
		"Banana Barrage":
			_spawn_banana_peels(position)
		"Oil Spill":
			_spawn_oil_splash(position)
		"Sweat Slip":
			_spawn_sweat_drops(position)
		"Energy Shot":
			_spawn_energy_sparks(position)
		_:
			_spawn_generic_confusion(position)

func _spawn_banana_peels(position: Vector2) -> void:
	for i in range(3):
		var peel := ColorRect.new()
	(peel.custom_minimum_size = Vector2(15, 8)
		peel.color = Color(0.95, 0.9, 0.2)
		peel.position = position + Vector2(randf_range(-40, 40), randf_range(-20, 10))
		peel.rotation = randf_range(-0.5, 0.5)
		particles_node.add_child(peel)
		
		# Animate falling
		var tween := create_tween()
		tween.tween_property(peel, "position:y", peel.position.y + 30, 0.8)
		tween.tween_property(peel, "modulate:a", 0.0, 0.8)
		tween.tween_callback(func(): peel.queue_free())

func _spawn_oil_splash(position: Vector2) -> void:
	for i in range(8):
		var drop := ColorRect.new()
		drop.custom_minimum_size = Vector2(6, 6)
		drop.color = Color(0.15, 0.15, 0.15)
		drop.position = position + Vector2(randf_range(-20, 20), randf_range(-10, 5))
		particles_node.add_child(drop)
		
		var tween := create_tween()
		tween.tween_property(drop, "position", position + Vector2(randf_range(-60, 60), 40), 0.6)
		tween.tween_property(drop, "modulate:a", 0.0, 0.6)
		tween.tween_callback(func(): drop.queue_free())

func _spawn_sweat_drops(position: Vector2) -> void:
	for i in range(5):
		var drop := ColorRect.new()
		drop.custom_minimum_size = Vector2(4, 8)
		drop.color = Color(0.6, 0.85, 1.0, 0.8)
		drop.position = position + Vector2(randf_range(-30, 30), -20)
		particles_node.add_child(drop)
		
		var tween := create_tween()
		tween.tween_property(drop, "position:y", drop.position.y + 50, 1.0)
		tween.tween_property(drop, "modulate:a", 0.0, 1.0)
		tween.tween_callback(func(): drop.queue_free())

func _spawn_energy_sparks(position: Vector2) -> void:
	for i in range(12):
		var spark := ColorRect.new()
		spark.custom_minimum_size = Vector2(3, 3)
		spark.color = Color(0.3, 0.9, 1.0)
		spark.position = position
		particles_node.add_child(spark)
		
		var angle := randf_range(0, TAU)
		var speed := randf_range(30, 80)
		var target := position + Vector2(cos(angle) * speed, sin(angle) * speed)
		
		var tween := create_tween()
		tween.tween_property(spark, "position", target, 0.4)
		tween.tween_property(spark, "modulate:a", 0.0, 0.4)
		tween.tween_callback(func(): spark.queue_free())

func _spawn_food_particles(position: Vector2) -> void:
	var emojis := ["🍔", "🌭", "🍕"]
	for i in range(3):
		var label := Label.new()
		label.text = emojis[randi() % emojis.size()]
		label.add_theme_font_size_override("font_size", 24)
		label.position = position + Vector2(randf_range(-30, 30), -10)
		particles_node.add_child(label)
		
		var tween := create_tween()
		tween.tween_property(label, "position:y", label.position.y - 40, 0.5)
		tween.tween_property(label, "modulate:a", 0.0, 0.5)
		tween.tween_callback(func(): label.queue_free())

func _spawn_generic_confusion(position: Vector2) -> void:
	for i in range(4):
		var star := Label.new()
		star.text = "⭐"
		star.add_theme_font_size_override("font_size", 16)
		star.position = position + Vector2(randf_range(-40, 40), randf_range(-30, -10))
		particles_node.add_child(star)
		
		var tween := create_tween()
		tween.tween_property(star, "rotation", star.rotation + PI, 0.6)
		tween.tween_property(star, "modulate:a", 0.0, 0.6)
		tween.tween_callback(func(): star.queue_free())
