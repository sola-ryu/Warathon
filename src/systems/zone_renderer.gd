## Visual renderer for cheat zones along the course
## Shows colored zone markers with labels on the race track
extends Node2D

@onready var cheat_zones_node := $CheatZones

func _ready() -> void:
	pass

func render_zones(segments: Array) -> void:
	# Clear existing zones
	for child in cheat_zones_node.get_children():
		cheat_zones_node.remove_child(child)
		child.queue_free()
	
	for seg in segments:
		var zone := _create_zone_visual(seg)
		if zone:
			cheat_zones_node.add_child(zone)

func _create_zone_visual(segment: Dictionary) -> Control:
	var type := segment["type"]
	var start_x := segment["start"] * 2.0  # Scale for visual
	var width := segment["length"] * 2.0
	
	var panel := ColorRect.new()
	panel.custom_minimum_size = Vector2(width, 60)
	panel.position = Vector2(start_x, 540)
	
	var label := Label.new()
	label.text = _zone_label(type)
	label.add_theme_font_size_override("font_size", 16)
	label.horizontal_alignment = 1
	label.position = Vector2(width / 2 - 50, 540 + 30)
	label.add_theme_color_override("font_color", Color(1, 1, 1, 0.8))
	
	match type:
		0:  # ROAD
			panel.color = Color(0.3, 0.3, 0.3, 0.3)
			return null  # Roads don't need visual markers
		1:  # SPECTATOR_ZONE
			panel.color = Color(0.9, 0.7, 0.2, 0.4)
		2:  # FOOD_VENDOR
			panel.color = Color(0.8, 0.3, 0.2, 0.5)
		3:  # WATER_STATION
			panel.color = Color(0.2, 0.5, 0.9, 0.5)
		4:  # MEDICAL_TENT
			panel.color = Color(0.9, 0.2, 0.3, 0.5)
		5:  # BRIDGE
			panel.color = Color(0.6, 0.5, 0.3, 0.5)
		6:  # SHORTCUT
			panel.color = Color(0.2, 0.8, 0.3, 0.5)
		7:  # OBSTACLE
			panel.color = Color(0.8, 0.1, 0.1, 0.4)
	
	var container := VBoxContainer.new()
	container.add_child(panel)
	container.add_child(label)
	return container

func _zone_label(type: int) -> String:
	match type:
		1: return "👥 Spectators"
		2: return "🍔 Food Vendor"
		3: return "💧 Water Station"
		4: return "🏥 Medical Tent"
		5: return "🌉 Bridge"
		6: return "⚡ Shortcut"
		7: return "⚠️ Obstacle"
		_: return ""
