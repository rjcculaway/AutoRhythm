extends Control

onready var beat_map_generator: Node = $BeatMapGenerator
onready var music_player: AudioStreamPlayer = $MusicPlayer
var beat_map = []

signal beat_channels_ready()

# Called when the node enters the scene tree for the first time.
func _ready():
	beat_map = beat_map_generator.generate_random_beat_map(music_player.stream)
	var beat_lanes = ($MarginContainer/BeatLanes).get_children()
	for beat_lane in beat_lanes:
		beat_lane.beat_channel = beat_map
	emit_signal("beat_channels_ready")

func _on_pressed_beat(lane_id):
	pass

# Wait for three (3) seconds before the track starts
func _on_StartTimer_timeout():
	music_player.play()
