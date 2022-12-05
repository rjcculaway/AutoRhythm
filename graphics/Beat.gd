extends Node2D

class_name Beat

export var beat_timestamp = 0.0

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
	var old_position = self.position[1]
	var new_position = lerp(STARTING_POSITION, final_position, progress)
	self.position[1] = new_position
	return

func finish_displaying():
	self.queue_free()
	return
