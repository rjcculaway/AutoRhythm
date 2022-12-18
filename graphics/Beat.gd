extends Node2D

class_name Beat

export var beat_timestamp = 0.0

onready var color_tween: Tween = $ColorTween
onready var beat_circle: AntialiasedRegularPolygon2D = $BeatCircle

const STARTING_POSITION = -96.0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _enter_tree():
	self.position[1] = STARTING_POSITION
	return

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_position(playback_position, final_position):
	var distance = clamp(beat_timestamp - playback_position, 0.0, GameSettings.adjacency_radius)
	var progress = 1 - distance / GameSettings.adjacency_radius
	var new_position = lerp(STARTING_POSITION, final_position, progress)
	self.position[1] = new_position
	return
	
func activate_beat():
	var _interpolate_result = color_tween.interpolate_property(beat_circle, "color",
		beat_circle.color, Color.coral, 0.125,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	var _result = color_tween.start()

	return
	
func deactivate_beat():
	var _interpolate_result = color_tween.interpolate_property(beat_circle, "color",
		beat_circle.color, Color.white, 0.125,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	var _result = color_tween.start()
	self.queue_free()
	
	return
