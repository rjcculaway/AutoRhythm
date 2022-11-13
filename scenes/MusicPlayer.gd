extends AudioStreamPlayer

signal audio_progressed(playback_position, playing)
var previous_playback_position: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	previous_playback_position = self.get_playback_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var playback_position = self.get_playback_position()
	emit_signal("audio_progressed", playback_position, self.playing)
	previous_playback_position = playback_position
	
