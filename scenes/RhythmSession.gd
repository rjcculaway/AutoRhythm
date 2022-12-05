extends Control

onready var beat_map_generator: Node = $BeatMapGenerator
onready var music_player: AudioStreamPlayer = $MusicPlayer

func get_earliest_timestamp(beat_map):
	return beat_map[0]

# Called when the node enters the scene tree for the first time.
func _ready():
	var beat_map = beat_map_generator.generate_random_beat_map(music_player.stream)
	var earliest_timestamp = get_earliest_timestamp(beat_map)
	var beat_lanes = ($MarginContainer/BeatLanes).get_children()
	var offset = GameSettings.adjacency_radius - earliest_timestamp
	for beat_lane in beat_lanes:
		beat_lane.load_beat_channel(beat_map, offset)
		beat_lane.play()
	if offset > 0:
		var timer = get_tree().create_timer(offset)
		timer.connect("timeout", self, "on_delay_timer_finished")

func on_delay_timer_finished():
	music_player.play()
