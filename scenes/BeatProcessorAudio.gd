extends AudioStreamPlayer

# RMS stands for the root mean square
const ROOT_MEAN_SQUARE_SAMPLES = 10	# Determines the number of samples for the root mean square
const FREQ_MIN = 80.0
const FREQ_MAX = 140.0
const MIN_DB = 60

const POSSIBLE_LANES = ["beat_a", "beat_s", "beat_d", "beat_f"]

signal beat_should_occur_at(timestamp, beat_lane)
signal first_beat(timestamp)
signal new_energy(energy)

var previous_root_mean_square: float = 0.0
var previous_progress: float = 0.0
var previous_derivative: float = 0.0
var has_first_beat: bool = false
var energies: Array = []
onready var spectrum = AudioServer.get_bus_effect_instance(1, 0)

func _process(_delta):
	var current_progress = 0.0
	if not self.playing:
		return

	current_progress = self.get_playback_position() + AudioServer.get_time_since_last_mix()
	var audio_delta = (current_progress - previous_progress)

	var magnitude: float = spectrum.get_magnitude_for_frequency_range(FREQ_MIN, FREQ_MAX, 1).length()
	var energy = clamp((MIN_DB + linear2db(magnitude)) / MIN_DB, 0, 1) # the "height"

	if energies.size() == ROOT_MEAN_SQUARE_SAMPLES:
		energies.pop_back()
	energies.push_front(energy)

	var root_mean_square = computeRootMeanSquare(energies)
	emit_signal("new_energy", root_mean_square)

	# Use the geometric interpretation of the derivative
	# x is the time, meaning that delta is the change in time
	# f(x) is the root mean square at that point in time
	var derivative = (root_mean_square - previous_root_mean_square) / audio_delta
	# Get the second derivative. This is used to check if it is the local maxima.
	var second_derivative = (derivative - previous_derivative) / audio_delta

	var is_extrema = is_equal_approx(derivative, 0.0)
	var is_local_maxima = second_derivative < 0.0

	# var format_string = "Derivative: %d\tSecond Derivative: %d"
	# print(format_string % [derivative, second_derivative])
	if is_extrema and is_local_maxima:
		if not has_first_beat:
			has_first_beat = true
			emit_signal("first_beat", previous_progress)

		if not is_equal_approx(previous_derivative, 0.0):
			emit_signal("beat_should_occur_at", previous_progress, POSSIBLE_LANES[randi() % POSSIBLE_LANES.size()])
		# print("should emit beat!")
	previous_root_mean_square = root_mean_square
	previous_progress = current_progress
	previous_derivative = derivative
	# print("beat processor: ", current_progress)
	return

func computeRootMeanSquare(samples):
	var sum = 0

	for sample in samples:
		sum = sum + pow(sample, 2)

	var root_mean_square: float = sqrt(sum / samples.size())
	return root_mean_square

