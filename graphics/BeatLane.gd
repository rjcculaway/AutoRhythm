extends Control

class_name BeatLane

export var key_press = ""
export var beat_channel: Array = []
onready var lane: ColorRect = $Lane
onready var beats: Control = $Beats
onready var beat_target: MarginContainer = $BeatTarget
const active_color = Color(1, 1, 1, 0.5)
const inactive_color = Color(0, 0, 0, 0.5)
const ADJACENCY_RADIUS: float = 2.0

var beat_scene: PackedScene = preload("res://graphics/Beat.tscn")
var beat_scenes: Array = []

var current_playback_position: float = 0.0

signal pressed_beat(lane_id)
var beat_channel_size = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	match event.get_class():
		"InputEventKey":
			if event.is_action_pressed(key_press):
				lane.color = active_color
				emit_signal("pressed_beat", self.name)
			if event.is_action_released(key_press):
				lane.color = inactive_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var index_nearest = beat_channel.bsearch(current_playback_position)
	for beat in beats.get_children():
		var beat_distance: float = 1 - (abs(current_playback_position - beat_channel[beat.beat_index]) / ADJACENCY_RADIUS)
		(beat as Beat).position = Vector2(0, lerp(-96, beat_target.rect_global_position[1], beat_distance))
		if (beat as Beat).beat_index < index_nearest:
			beat.queue_free()

func _on_audio_progressed(playback_position):
	current_playback_position = playback_position
	return


func _on_beat_channels_ready():
	beat_channel_size = beat_channel.size()
	for i in range(beat_channel_size):
		var new_beat = beat_scene.instance()
		new_beat.beat_index = i
		beats.add_child(new_beat)
	return
