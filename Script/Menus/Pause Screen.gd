extends Menu

signal button_pressed(value)


func _ready():
	buttonContainer = $"Pause Menu"
	._ready()


func _on_Resume_pressed():
	emit_signal("button_pressed", 'resume')
	print('resume')


func _on_Options_pressed():
	emit_signal("button_pressed", 'options')



func _on_Exit_pressed():
	emit_signal("button_pressed", 'quit')
	print('quit')
