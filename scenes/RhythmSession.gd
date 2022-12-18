extends Control

onready var beat_map_generator: Node = $BeatMapGenerator
onready var beat_processor_audio: AudioStreamPlayer = $BeatProcessorAudio
onready var music_player: AudioStreamPlayer = $MusicPlayer

func get_earliest_timestamp(beat_map):
	return beat_map[0]

# Called when the node enters the scene tree for the first time.
func _ready():
	beat_processor_audio.play()

func on_delay_timer_finished():
	music_player.play()

func on_first_beat_generated(timestamp):
	print("first beat generated!")
	var offset = GameSettings.adjacency_radius - timestamp

	var beat_lanes = ($MarginContainer/BeatLanes).get_children()
	for beat_lane in beat_lanes:
		beat_lane.load_beat_channel(offset)
		beat_lane.play()

	if offset > 0:
		var timer = get_tree().create_timer(offset)
		timer.connect("timeout", self, "on_delay_timer_finished")
	else:
		music_player.play()
