extends Node2D

func _on_Start_pressed():
	get_tree().change_scene("Scenes/Main.tscn")

func _on_Exit_pressed():
	get_tree().quit()
