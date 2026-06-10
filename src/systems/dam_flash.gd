## WarioWare-style "DAM!" flash text overlay
extends CanvasLayer

@onready var damage_label: Label = $DamageLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_flashing := false

func _ready() -> void:
	damage_label.visible = false

func flash(text: String, color: Color = Color(1.0, 1.0, 0.0, 1.0)) -> void:
	if is_flashing:
		return
	is_flashing = true
	
	damage_label.text = text
	damage_label.add_theme_color_override("font_color", color)
	damage_label.visible = true
	
	# WarioWare-style flash: big, bold, brief
	var tween := create_tween()
	tween.tween_property(damage_label, "scale", Vector2(1.5, 1.5), 0.05)
	tween.tween_property(damage_label, "scale", Vector2(1.0, 1.0), 0.05)
	tween.tween_interval(0.15)
	tween.tween_property(damage_label, "modulate:a", 0.0, 0.1)
	
	await tween.finished
	damage_label.visible = false
	is_flashing = false

func flash_cheat(cheat_name: String) -> void:
	match cheat_name:
		"Sandwich Snatch":
			flash("🥪 SNATCH!", Color(0.9, 0.7, 0.2))
		"Banana Barrage":
			flash("🍌 BARRAGE!", Color(0.9, 0.9, 0.1))
		"Fake Police":
			flash("👮 DAM!", Color(1.0, 0.3, 0.3))
		"Oil Spill":
			flash("🛢️ SLIP!", Color(0.2, 0.2, 0.2))
		"Spectator Wall":
			flash("🧱 WALL!", Color(0.8, 0.5, 0.2))
		"Energy Shot":
			flash("💉 ZAP!", Color(0.3, 0.8, 1.0))
		"Shortcut Gate":
			flash("🚧 CUT!", Color(0.9, 0.9, 0.3))
		"Sweat Slip":
			flash("😅 SWEAT!", Color(0.5, 0.8, 1.0))
