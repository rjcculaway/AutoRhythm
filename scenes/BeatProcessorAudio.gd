extends AudioStreamPlayer

const FREQ_MAX = 11050.0
const MIN_DB = 60

signal beat_should_occur_at(timestamp)
signal first_beat(timestamp)

var previous_energy: float = 0.0
var has_first_beat: bool = false
onready var spectrum = AudioServer.get_bus_effect_instance(1, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var current_progress = 0.0
	if self.playing:
		current_progress = self.get_playback_position() + AudioServer.get_time_since_last_mix()

	var magnitude: float = spectrum.get_magnitude_for_frequency_range(1, FREQ_MAX).length()
	var energy = clamp((MIN_DB + linear2db(magnitude)) / MIN_DB, 0, 1) # the "height"
	if energy - previous_energy > 0.1:
		if not has_first_beat:
			has_first_beat = true
			emit_signal("first_beat", current_progress)
		emit_signal("beat_should_occur_at", current_progress)
		# print("should emit beat!")
	previous_energy = energy
	# print("beat processor: ", current_progress)

