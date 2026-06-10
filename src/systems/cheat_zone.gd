## A zone along the course where Wario can execute a specific cheat type
extends Area2D

signal zone_entered(zone_type: String)
signal zone_exited(zone_type: String)
signal cheat_triggered(cheat_name: String, success: bool)

@export var zone_type: String = "food_vendor"       # food_vendor, water_station, spectator, medical, bridge
@export var fuel_amount: float = 10.0                # How much fuel this zone provides
@export var available_cheats: Array[String] = []     # Which cheats can be used here

var is_active := true
var entered_count := 0

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _process(delta: float) -> void:
	if not is_active:
		return
	
	# Check if Wario is overlapping and can trigger a cheat
	var bodies := get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player"):
			_on_wario_in_zone(body)

func _on_area_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		entered_count += 1
		zone_entered.emit(zone_type)

func _on_area_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		zone_exited.emit(zone_type)

func _on_wario_in_zone(player: CharacterBody2D) -> void:
	# Auto-refuel when passing through zones
	if entered_count > 0 and randf() < 0.01:
		CheatManager.refill_fuel(fuel_amount * 0.1)

func trigger_cheat(cheat_name: String, distance: float) -> bool:
	if not available_cheats.has(cheat_name):
		return false
	
	var success := CheatManager.execute(cheat_name, distance)
	
	if success:
		cheat_triggered.emit(cheat_name, true)
		# Grant bonus fuel for using cheat in appropriate zone
		CheatManager.refill_fuel(fuel_amount * 0.3)
	else:
		cheat_triggered.emit(cheat_name, false)
	
	return success

func deactivate() -> void:
	is_active = false
	visible = false
	modulate = Color(0.5, 0.5, 0.5, 0.5)
