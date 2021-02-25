extends Control

class_name Menu

var buttonList = []
var selectedButton = -1

var buttonContainer = null

func _ready():
	if (buttonContainer):
		for _i in buttonContainer.get_children():
			if _i is Button:
				buttonList.append(_i)

func input():
	if buttonList.size() > 0:
		if Input.is_action_just_pressed("ui_up"):
			selectedButton = (selectedButton - 1 + (buttonList.size()))%(buttonList.size())
			
		if Input.is_action_just_pressed("ui_down"):
			selectedButton = (selectedButton + 1)%(buttonList.size())

func move_focus():
	if buttonList.size() > 0:
		var btn = buttonList[selectedButton]
		if selectedButton >= 0:
			btn.grab_focus()

func _process(delta):
	input()
	move_focus()
