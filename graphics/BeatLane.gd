extends Control

class_name BeatLane

export var key_press = ""
export var beat_channel: Array = []
onready var lane: ColorRect = $Lane
onready var beats: Control = $Beats
onready var beat_target: MarginContainer = $BeatTarget
const active_color = Color(1, 1, 1, 0.5)
const inactive_color = Color(0, 0, 0, 0.5)

var beat_scene: PackedScene = preload("res://graphics/Beat.tscn")
var beat_scenes: Array = []

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
				var particle_emitter: Particles2D = beat_target.get_node("AntialiasedRegularPolygon2D2/Particles2D")
				particle_emitter.restart()
				emit_signal("pressed_beat", self.name)
			if event.is_action_released(key_press):
				lane.color = inactive_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	return

func _on_beat_channels_ready():
	beat_channel_size = beat_channel.size()
	for i in range(beat_channel_size):
		var new_beat: Beat = beat_scene.instance()
		new_beat.beat_index = i
		new_beat.position = Vector2(34, -84)
		beats.add_child(new_beat)
		
		var tween: Tween = new_beat.get_node("Tween")
		var delay = beat_channel[i] - beat_channel[0]
		var beat_circle: AntialiasedRegularPolygon2D = new_beat.get_node("BeatCircle")
		tween.interpolate_property(new_beat, "position", new_beat.position, Vector2(34, beat_target.rect_global_position[1] + 32), GameSettings.ADJACENCY_RADIUS, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)
		tween.interpolate_property(new_beat, "position", Vector2(34, beat_target.rect_global_position[1] + 32), Vector2(32, get_viewport_rect().size[1] + 84), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay + GameSettings.ADJACENCY_RADIUS)
		tween.interpolate_property(beat_circle, "color", beat_circle.color, Color.transparent, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay + GameSettings.ADJACENCY_RADIUS)
		tween.interpolate_property(beat_circle, "stroke_color", beat_circle.stroke_color, Color.transparent, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay + GameSettings.ADJACENCY_RADIUS)
	return
	
func _on_begin_playing():
	for beat in beats.get_children():
		var tween: Tween = beat.get_node("Tween")
		tween.start()
