extends Control

signal button_pressed(value)


func _on_Pause_Screen_button_pressed(value):
	emit_signal("button_pressed", value)


func _on_Game_Over_Screen_button_pressed(value):
	emit_signal("button_pressed", value)
