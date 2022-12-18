extends Control

class_name BeatLane

export var key_press = ""
export var beat_channel: Array = []
export var is_playing: bool = false
onready var lane: ColorRect = $Lane
onready var beats: Control = $Beats
onready var beat_target: MarginContainer = $BeatTarget
const active_color = Color(1, 1, 1, 0.5)
const inactive_color = Color(0, 0, 0, 0.5)

var beat_scene: PackedScene = preload("res://graphics/Beat.tscn")
var beat_scenes: Array = []

var beat_channel_size = 0
var current_index = 0
var offset = 0
var sync_progress: float = 0.0
var current_audio_progress: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	match event.get_class():
		"InputEventKey":
			var particle_emitter: Particles2D = beat_target.get_node("HitParticles")
			if event.is_action_pressed(key_press):
				lane.color = active_color
				if self.is_playing and current_index < beat_channel_size:
					var distance_to_nearest_beat = abs(self.current_audio_progress - (beat_channel[current_index] + offset))
					# print(self.current_audio_progress, " ", beat_channel[current_index], " ", distance_to_nearest_beat)
					if distance_to_nearest_beat <= GameSettings.beat_tolerance:
						particle_emitter.emitting = true
			if event.is_action_released(key_press):
				lane.color = inactive_color
				particle_emitter.emitting = false

# Loads a beat channel onto this beat lane. Assumes that the beat channel is sorted numerically in ascending order.
func load_beat_channel(new_offset):
	self.beat_channel = []
	self.beat_channel_size = beat_channel.size()
	self.current_index = 0
	self.offset = new_offset
	
	# for i in range(beat_channel_size):
	# 	var new_beat = beat_scene.instance()
	# 	new_beat.beat_timestamp = beat_channel[i] + self.offset
	# 	beat_scenes.append(new_beat)
	# 	beats.add_child(new_beat)
	
	return

func queue_beat(timestamp):
	self.beat_channel.append(timestamp)
	self.beat_channel_size = beat_channel.size()

	var new_beat = beat_scene.instance()
	new_beat.beat_timestamp = timestamp + self.offset
	beat_scenes.append(new_beat)
	beats.add_child(new_beat)

func play():
	self.is_playing = true

func pause():
	self.is_playing = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.is_playing:
		self.sync_progress = min(offset, self.sync_progress + delta)
		while current_index < beat_channel_size and self.current_audio_progress >= beat_channel[current_index] + offset:
			current_index = current_index + 1
		for beat in beats.get_children():
			beat.update_position(current_audio_progress, beat_target.rect_global_position[1] + beat_target.get_rect().size[1] / 2)
			if current_index < beat_channel_size:
				if is_equal_approx(beat_channel[current_index] + offset, beat.beat_timestamp):
					beat.activate_beat()
				elif beat_channel[current_index] + offset > beat.beat_timestamp:
					beat.deactivate_beat()
	return

func on_playback_progressed(playback_position):
	self.current_audio_progress = playback_position + self.sync_progress
