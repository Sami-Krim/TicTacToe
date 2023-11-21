extends Control

signal play(first)



func _on_play_button_pressed() -> void:
	$AnimationPlayer.play("show")

func _on_x_button_pressed() -> void:
	emit_signal("play", false)


func _on_o_button_pressed() -> void:
	emit_signal("play", true)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
