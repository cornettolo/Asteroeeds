extends Control

onready var PlayButton = $"MarginContainer/HBoxContainer/VBoxContainer/Play"
onready var OptionsButton = $"MarginContainer/HBoxContainer/VBoxContainer/Options"
onready var ExitButton = $"MarginContainer/HBoxContainer/VBoxContainer/Quit"

onready var buttonList = [ $"MarginContainer/HBoxContainer/VBoxContainer/Play", $"MarginContainer/HBoxContainer/VBoxContainer/Options", $"MarginContainer/HBoxContainer/VBoxContainer/Quit" ]

var selectedButton = 0


func input():
	if Input.is_action_just_pressed("ui_up"):
		selectedButton = (selectedButton + 1)%(buttonList.size()) + 1
		
	if Input.is_action_just_pressed("ui_down"):
		selectedButton = (selectedButton + buttonList.size())%(buttonList.size()) + 1

	

func move_focus():
	var btn = buttonList[selectedButton - 1]
	if selectedButton >= 1:
		btn.grab_focus()

func _process(delta):
	input()
	move_focus()


func _on_Play_pressed():
	print('play pressed')
	get_tree().change_scene("res://Scenes/Playground.tscn")


func _on_Options_pressed():
	pass # Replace with function body.


func _on_Quit_pressed():
	get_tree().quit()
