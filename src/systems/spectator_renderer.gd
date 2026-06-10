## Spectator crowd renderer — generates crowd figures along the course
extends Node2D

@onready var spectators_node := $Spectators

func _ready() -> void:
	pass

func render_spectators(segments: Array) -> void:
	for child in spectators_node.get_children():
		spectators_node.remove_child(child)
		child.queue_free()
	
	for seg in segments:
		if seg["type"] != 1:  # Only spectator zones
			continue
		
		var count := randi_range(8, 20)
		var start_x := seg["start"] * 2.0
		var width := seg["length"] * 2.0
		
		for i in range(count):
			var spectator := _create_spectator()
			spectator.position.x = start_x + (i / float(count)) * width
			spectators_node.add_child(spectator)

func _create_spectator() -> Control:
	var container := VBoxContainer.new()
	container.custom_minimum_size = Vector2(16, 30)
	
	# Head (circle-ish via ColorRect)
	var head := ColorRect.new()
	head.color = _random_skin_tone()
	head.custom_minimum_size = Vector2(12, 12)
	head.position = Vector2(2, 0)
	container.add_child(head)
	
	# Body
	var body := ColorRect.new()
	body.color = _random_clothing_color()
	body.custom_minimum_size = Vector2(14, 15)
	body.position = Vector2(1, 13)
	container.add_child(body)
	
	return container

func _random_skin_tone() -> Color:
	var tones := [
		Color(0.95, 0.85, 0.7),
		Color(0.85, 0.7, 0.55),
		Color(0.75, 0.6, 0.45),
		Color(0.65, 0.5, 0.35),
		Color(0.9, 0.8, 0.65),
	]
	return tones[randi() % tones.size()]

func _random_clothing_color() -> Color:
	var colors := [
		Color(0.3, 0.3, 0.8),   # Blue
		Color(0.8, 0.2, 0.2),   # Red
		Color(0.2, 0.6, 0.2),   # Green
		Color(0.9, 0.9, 0.3),   # Yellow
		Color(0.5, 0.2, 0.6),   # Purple
		Color(0.9, 0.5, 0.3),   # Orange
		Color(0.3, 0.3, 0.3),   # Black
		Color(0.9, 0.9, 0.9),   # White
	]
	return colors[randi() % colors.size()]
