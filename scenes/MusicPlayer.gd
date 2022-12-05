extends AudioStreamPlayer
var previous_playback_position = 0.0

signal playback_progressed(playback_position)

# Called when the node enters the scene tree for the first time.
func _ready():
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var playback_position = self.get_playback_position()
	if playback_position > previous_playback_position:
		self.previous_playback_position = playback_position
		emit_signal("playback_progressed", playback_position)
	return
	
