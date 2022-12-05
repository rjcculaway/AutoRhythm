extends Control

var new_game_scene = preload("res://scenes/RhythmSession.tscn")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NewSong_pressed():
	var result = get_tree().change_scene_to(new_game_scene)
	assert(result == OK)
	return
