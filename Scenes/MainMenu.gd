extends Control

onready var PlayButton = $"MarginContainer/HBoxContainer/VBoxContainer/Play"
onready var OptionsButton = $"MarginContainer/HBoxContainer/VBoxContainer/Options"
onready var ExitButton = $"MarginContainer/HBoxContainer/VBoxContainer/Quit"


func _on_Play_pressed():
	get_tree().change_scene("res://Scenes/Playground.tscn")


func _on_Options_pressed():
	pass # Replace with function body.


func _on_Quit_pressed():
	get_tree().quit()
