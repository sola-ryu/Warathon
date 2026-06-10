## Procedural course segment generator
extends Node

signal segment_generated(position: float, segment_type: String)

enum SegmentType { ROAD, SPECTATOR_ZONE, FOOD_VENDOR, WATER_STATION, MEDICAL_TENT, BRIDGE, SHORTCUT, OBSTACLE }

const SEGMENT_LENGTHS := {
	SegmentType.ROAD: [200.0, 400.0],
	SegmentType.SPECTATOR_ZONE: [150.0, 300.0],
	SegmentType.FOOD_VENDOR: [100.0, 200.0],
	SegmentType.WATER_STATION: [100.0, 200.0],
	SegmentType.MEDICAL_TENT: [80.0, 150.0],
	SegmentType.BRIDGE: [120.0, 250.0],
	SegmentType.SHORTCUT: [60.0, 100.0],
	SegmentType.OBSTACLE: [80.0, 180.0],
}

const WEIGHTS := {
	SegmentType.ROAD: 40,
	SegmentType.SPECTATOR_ZONE: 20,
	SegmentType.FOOD_VENDOR: 10,
	SegmentType.WATER_STATION: 10,
	SegmentType.MEDICAL_TENT: 8,
	SegmentType.BRIDGE: 5,
	SegmentType.SHORTCUT: 3,
	SegmentType.OBSTACLE: 4,
}

# Stage themes affect segment availability
const STAGE_CONFIG := {
	"city": {
		"enabled": [SegmentType.ROAD, SegmentType.SPECTATOR_ZONE, SegmentType.FOOD_VENDOR, SegmentType.BRIDGE],
		"background_color": Color(0.3, 0.3, 0.35),
		"ground_color": Color(0.2, 0.2, 0.25),
	},
	"park": {
		"enabled": [SegmentType.ROAD, SegmentType.SPECTATOR_ZONE, SegmentType.WATER_STATION, SegmentType.SHORTCUT],
		"background_color": Color(0.4, 0.6, 0.3),
		"ground_color": Color(0.25, 0.4, 0.2),
	},
	"bowser": {
		"enabled": [SegmentType.ROAD, SegmentType.OBSTACLE, SegmentType.BRIDGE, SegmentType.MEDICAL_TENT],
		"background_color": Color(0.5, 0.15, 0.1),
		"ground_color": Color(0.3, 0.1, 0.05),
	},
	"dream": {
		"enabled": [SegmentType.ROAD, SegmentType.SPECTATOR_ZONE, SegmentType.SHORTCUT, SegmentType.OBSTACLE],
		"background_color": Color(0.6, 0.3, 0.7),
		"ground_color": Color(0.4, 0.2, 0.5),
	},
}

var current_stage := "city"
var course_segments := []
var total_course_length := 1500.0  # meters per race (scaled)

func set_stage(stage_name: String) -> void:
	current_stage = stage_name

func generate_course() -> Array:
	course_segments.clear()
	var pos := 0.0
	
	while pos < total_course_length:
		var segment := _pick_segment(pos)
		if segment == null:
			break
		
		course_segments.append(segment)
		pos += segment["length"]
	
	return course_segments

func get_stage_config() -> Dictionary:
	return STAGE_CONFIG.get(current_stage, STAGE_CONFIG["city"])

func _pick_segment(position: float) -> Dictionary:
	var stage_cfg := STAGE_CONFIG.get(current_stage, STAGE_CONFIG["city"])
	var enabled := stage_cfg["enabled"]
	
	if enabled.is_empty():
		return null
	
	# Weighted random selection
	var total_weight := 0
	for seg_type in enabled:
		total_weight += WEIGHTS.get(seg_type, 1)
	
	var roll := randf() * total_weight
	var cumulative := 0
	
	for seg_type in enabled:
		cumulative += WEIGHTS.get(seg_type, 1)
		if roll <= cumulative:
			var length_range := SEGMENT_LENGTHS[seg_type]
			var length := randf_range(length_range[0], length_range[1])
			return {
				"type": seg_type,
				"start": position,
				"length": length,
				"fuel_reward": _fuel_for_type(seg_type),
			}
	
	# Fallback to road
	var length_range := SEGMENT_LENGTHS[SegmentType.ROAD]
	return {
		"type": SegmentType.ROAD,
		"start": position,
		"length": randf_range(length_range[0], length_range[1]),
		"fuel_reward": 0,
	}

func _fuel_for_type(seg_type: SegmentType) -> float:
	match seg_type:
		SegmentType.SPECTATOR_ZONE: return 15.0
		SegmentType.FOOD_VENDOR: return 10.0
		SegmentType.WATER_STATION: return 8.0
		SegmentType.MEDICAL_TENT: return 12.0
		_: return 0.0
