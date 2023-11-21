extends Control

#this screen displays whether the player won, lost or ended in draw


@onready var msg = get_node("Message")

func update_text(txt: String)->void:
	msg.text = txt
