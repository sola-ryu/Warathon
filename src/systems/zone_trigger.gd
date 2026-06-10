## Cheat zone trigger handler — processes zones as Wario passes through them
extends Node2D

signal zone_triggered(zone_type: String, fuel_gained: float)

@onready var race_scene := get_parent()

# Zone type to cheat mapping
const ZONE_CHEAT_MAP := {
	"food_vendor": ["Sandwich Snatch", "Energy Shot"],
	"water_station": ["Banana Barrage", "Oil Spill"],
	"spectator_zone": ["Spectator Wall", "Sweat Slip"],
	"medical_tent": ["Energy Shot", "Shortcut Gate"],
	"bridge": ["Shortcut Gate", "Fake Police"],
}

# Zone type to fuel reward
const ZONE_FUEL := {
	"food_vendor": 15.0,
	"water_station": 10.0,
	"spectator_zone": 20.0,
	"medical_tent": 12.0,
	"bridge": 8.0,
}

var active_zones := {}
var zone_cooldowns := {}

func _process(delta: float) -> void:
	for zone_id in active_zones:
		var zone := active_zones[zone_id]
		
		# Check if Wario is overlapping this zone
		if race_scene and race_scene.has_node("Wario"):
			var wario_pos := race_scene.get_node("Wario").position
			var zone_rect := zone.get_node_or_null("HitBox")
			
			if zone_rect:
				var zone_bounds := zone_rect.get_global_rect()
				if wario_pos.x >= zone_bounds.position.x and wario_pos.x <= zone_bounds.end.x:
					_on_wario_in_zone(zone, zone_id)

func _on_wario_in_zone(zone: Node2D, zone_id: String) -> void:
	# Check cooldown
	if zone_id in zone_cooldowns:
		zone_cooldowns[zone_id] -= get_tree().process_delta
		if zone_cooldowns[zone_id] > 0:
			return
	
	# Grant fuel
	var zone_type := zone.get("zone_type", "spectator_zone")
	var fuel := ZONE_FUEL.get(zone_type, 5.0)
	CheatManager.refill_fuel(fuel)
	
	zone_cooldowns[zone_id] = 2.0  # 2 second cooldown per zone
	
	zone_triggered.emit(zone_type, fuel)

func add_zone(zone: Node2D, zone_id: String) -> void:
	active_zones[zone_id] = zone

func remove_zone(zone_id: String) -> void:
	if zone_id in active_zones:
		active_zones.erase(zone_id)
