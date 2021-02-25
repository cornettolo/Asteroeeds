extends Menu

signal button_pressed(value)


func _ready():
	buttonContainer = $"Game Over Menu"
	._ready()

	

func _on_Options_pressed():
	emit_signal("button_pressed", 'options')


func _on_Exit_pressed():
	emit_signal("button_pressed", 'quit')


func _on_Restart_pressed():	
	emit_signal("button_pressed", 'restart')
