## Audio manager placeholder — handles SFX and music
## Future: integrate with Godot's AudioServer for actual sounds
extends Node

signal sfx_played(sfx_name: String)
signal music_changed(track_name: String)

# Track names per stage
const STAGE_MUSIC := {
	"city": "cheesy_jazz_funk",
	"park": "nature_remix",
	"bowser": "lava_chaos_theme",
	"dream": "surreal_microgame_boss",
	"finish": "victory_laugh_mashup",
}

# Cheat SFX names
const CHEAT_SFX := {
	"Sandwich Snatch": "snack_grab",
	"Banana Barrage": "banana_throw",
	"Fake Police": "siren_wail",
	"Oil Spill": "oil_splash",
	"Spectator Wall": "crowd_cheer",
	"Energy Shot": "energy_zap",
	"Shortcut Gate": "barrier_tear",
	"Sweat Slip": "sweat_squish",
}

var current_music := ""
var sfx_volume := 0.8
var music_volume := 0.6

func play_sfx(sfx_name: String) -> void:
	sfx_played.emit(sfx_name)
	# TODO: Play actual SFX via AudioServer
	print("[Audio] Playing SFX: ", sfx_name)

func play_cheat_sfx(cheat_name: String) -> void:
	var sfx: String = CHEAT_SFX.get(cheat_name, "generic_boop")
	play_sfx(sfx)

func start_music(track_name: String) -> void:
	current_music = track_name
	music_changed.emit(track_name)
	# TODO: Start actual music via AudioServer
	print("[Audio] Starting music: ", track_name)

func stop_music() -> void:
	current_music = ""
	# TODO: Stop music via AudioServer

func change_stage_music(stage_name: String) -> void:
	var track: String = STAGE_MUSIC.get(stage_name, "cheesy_jazz_funk")
	if track != current_music:
		stop_music()
		start_music(track)
