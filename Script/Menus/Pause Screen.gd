extends Menu

signal button_pressed(value)


func _on_Resume_pressed():
	emit_signal("button_pressed", 'resume')
	


func _on_Options_pressed():
	emit_signal("button_pressed", 'options')



func _on_Exit_pressed():
	emit_signal("button_pressed", 'exit')
