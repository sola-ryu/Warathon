## WarioWare-style cheat vignette — garish border effect during cheat execution
extends CanvasLayer

@onready var vignette: ColorRect = $VignetteRect

var is_active := false

func _ready() -> void:
	vignette.visible = false

func activate(color: Color = Color(1.0, 0.8, 0.0, 0.6)) -> void:
	if is_active:
		return
	is_active = true
	
	vignette.color = color
	vignette.visible = true
	
	# Flash effect
	var tween := create_tween()
	tween.tween_property(vignette, "modulate:a", 1.0, 0.05)
	tween.tween_property(vignette, "modulate:a", 0.3, 0.15)
	tween.tween_property(vignette, "modulate:a", 0.8, 0.05)
	tween.tween_property(vignette, "modulate:a", 0.3, 0.2)
	
	await tween.finished
	deactivate()

func deactivate() -> void:
	is_active = false
	vignette.visible = false
