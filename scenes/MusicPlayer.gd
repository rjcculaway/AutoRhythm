extends AudioStreamPlayer

signal playback_progressed(playback_position)

# Called when the node enters the scene tree for the first time.
func _ready():
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.playing:
		var playback_position = self.get_playback_position() + AudioServer.get_time_since_last_mix()
		emit_signal("playback_progressed", playback_position)
		# print("music_player", playback_position)
	return
	
