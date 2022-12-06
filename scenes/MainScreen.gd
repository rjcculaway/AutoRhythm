extends Control

var new_game_scene = preload("res://scenes/RhythmSession.tscn")

func _on_NewSong_pressed():
	var result = get_tree().change_scene_to(new_game_scene)
	assert(result == OK)
	return
