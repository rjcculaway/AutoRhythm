extends Node
const NUMBER_OF_BEATS = 512

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func generate_random_beat_map(audio_stream: AudioStreamSample) -> Array:
#	print(audio_stream)
#	var random = RandomNumberGenerator.new()
#	random.randomize()
#	var beat_map = []
#	for _beat_n in range(NUMBER_OF_BEATS):
#		beat_map.append(random.randf_range(0.0, audio_stream.get_length()))
#
#	beat_map.sort()
#	return beat_map
	return [1.5, 2.06, 2.63, 3.188, 4.3, 4.686, 4.873, 5.06]
	
