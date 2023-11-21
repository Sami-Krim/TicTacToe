extends Control

@onready var you_play_as = get_node("TextureRect")
@onready var wins = get_node("wins")
@onready var loses = get_node("loses")

var textures = [preload("res://Assets/X.png"), preload("res://Assets/O.png")]

func update_wins(wn: int, ls: int) -> void:
	wins.text = "Wins: "+str(wn)
	loses.text = "loses: "+str(ls)

func play_as(x_or_o: bool)->void:
	you_play_as.texture = textures[int(x_or_o)]
