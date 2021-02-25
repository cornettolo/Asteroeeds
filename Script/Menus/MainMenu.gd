extends Menu

func _ready():
	buttonContainer = $"MarginContainer/HBoxContainer/VBoxContainer"
	._ready()

func _on_Play_pressed():
	print('play pressed')
	get_tree().change_scene("res://Scenes/Playground.tscn")


func _on_Options_pressed():
	print('a') # Replace with function body.


func _on_Quit_pressed():
	get_tree().quit()
