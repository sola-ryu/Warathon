## Wario character sprite generator — creates placeholder pixel art sprites
## Run this to generate base sprites for Wario
extends Node

func _ready() -> void:
	_generate_all_sprites()

func _generate_all_sprites() -> void:
	var output_dir := "res://assets/sprites/"
	
	# Wario standing (frame 0)
	var standing := Image.create(64, 80, false, Image.FORMAT_RGBA8)
	for x in range(64):
		for y in range(80):
			var color := _wario_color(x, y, "standing")
			standing.set_pixel(x, y, color)
	_image_save(standing, output_dir + "wario_standing.png")
	
	# Wario cheating (frame 1) — mischievous grin
	var cheating := Image.create(64, 80, false, Image.FORMAT_RGBA8)
	for x in range(64):
		for y in range(80):
			var color := _wario_color(x, y, "cheating")
			cheating.set_pixel(x, y, color)
	_image_save(cheating, output_dir + "wario_cheating.png")
	
	# Wario boosting (frame 2) — speed lines
	var boosting := Image.create(64, 80, false, Image.FORMAT_RGBA8)
	for x in range(64):
		for y in range(80):
			var color := _wario_color(x, y, "boosting")
			boosting.set_pixel(x, y, color)
	_image_save(boosting, output_dir + "wario_boosting.png")
	
	# Wario slipping (frame 3) — legs out
	var slipping := Image.create(64, 80, false, Image.FORMAT_RGBA8)
	for x in range(64):
		for y in range(80):
			var color := _wario_color(x, y, "slipping")
			slipping.set_pixel(x, y, color)
	_image_save(slipping, output_dir + "wario_slipping.png")

func _wario_color(x: int, y: int, state: String) -> Color:
	# Wario's iconic yellow + purple
	var head_top := 5
	var head_bottom := 25
	var body_top := 25
	var body_bottom := 60
	var legs_top := 60
	var legs_bottom := 80
	
	# Hat (purple)
	if y >= head_top and y <= head_top + 8:
		if x >= 15 and x <= 49:
			return Color(0.35, 0.15, 0.5)
		elif x >= 10 and x <= 15 and y == head_top + 6:
			return Color(0.35, 0.15, 0.5)  # Hat brim
	
	# "W" on hat
	if y >= head_top + 3 and y <= head_top + 7:
		if x >= 28 and x <= 36:
			return Color(1.0, 1.0, 1.0)
	
	# Head (skin tone)
	if y > head_top + 8 and y < head_bottom:
		if x >= 15 and x <= 49:
			match state:
				"standing":
					return Color(0.95, 0.85, 0.6)
				"cheating":
					return Color(0.95, 0.85, 0.6)
				"boosting":
					return Color(1.0, 0.9, 0.7)
				"slipping":
					return Color(0.9, 0.8, 0.5)
	
	# Eyes
	if y >= 12 and y <= 16:
		if (x >= 22 and x <= 26) or (x >= 38 and x <= 42):
			return Color(0.1, 0.1, 0.1)
	
	# Nose (big Wario nose)
	if y >= 18 and y <= 22:
		if x >= 29 and x <= 35:
			return Color(0.95, 0.75, 0.5)
	
	# Mouth/grin
	if y >= 23 and y <= 25:
		if x >= 24 and x <= 40:
			match state:
				"cheating":
					return Color(0.8, 0.1, 0.1)  # Evil grin
				"boosting":
					return Color(0.9, 0.9, 0.3)  # Intense
				_:
					return Color(0.6, 0.3, 0.2)
	
	# Body (purple shirt)
	if y >= body_top and y < body_bottom:
		if x >= 12 and x <= 52:
			if y >= 35 and y <= 45:
				return Color(0.6, 0.3, 0.8)  # Belt area
			return Color(0.4, 0.2, 0.55)
	
	# Gloves (yellow)
	if y >= body_top + 5 and y <= body_bottom - 10:
		if (x >= 5 and x <= 12) or (x >= 52 and x <= 59):
			return Color(1.0, 0.95, 0.3)
	
	# Legs (blue pants)
	if y >= legs_top and y < legs_bottom:
		if (x >= 18 and x <= 28) or (x >= 36 and x <= 46):
			return Color(0.15, 0.25, 0.6)
	
	# Shoes (brown)
	if y >= legs_bottom - 5:
		if (x >= 15 and x <= 30) or (x >= 34 and x <= 49):
			return Color(0.4, 0.25, 0.1)
	
	# Speed lines for boosting state
	if state == "boosting":
		if y >= 20 and y <= 70:
			if x < 10 and x > 0 and (y % 8 == 0):
				return Color(1.0, 1.0, 1.0, 0.5)
	
	return Color(0.0, 0.0, 0.0, 0.0)

func _image_save(img: Image, path: String) -> void:
	var dir := DirAccess.open("res://assets/sprites/")
	if dir == null:
		dir = DirAccess.make_absolute_dir("res://assets/sprites/")
	img.save_png(path)
	print("Saved sprite: ", path)
