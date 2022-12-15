extends Node
const NUMBER_OF_BEATS = 512

const FREQ_MAX = 11050.0
const DELTA = 0.125

const WIDTH = 400

const MIN_DB = 60

var spectrum

func _ready():
	print()
	spectrum = AudioServer.get_bus_effect_instance(0,0)

func generate_random_beat_map(audio_stream_player: AudioStreamPlayer) -> Array:
	#warning-ignore:integer_division
	var beat_map = []
	var steps: float = int(floor(audio_stream_player.stream.get_length() / DELTA))
	var energies = []
	for i in range(steps):
		var magnitude: float = spectrum.get_magnitude_for_frequency_range(1, FREQ_MAX).length()
		var energy = clamp((MIN_DB + linear2db(magnitude)) / MIN_DB, 0, 1) # the "height"
		energies.append(energy)
		audio_stream_player.seek(audio_stream_player.get_playback_position() + DELTA)
	
	print(energies)
	# return beat_map
	return [1.5, 2.06, 2.63, 3.188, 4.3, 4.686, 4.873, 5.06]
	
