extends Node2D

#This object controls the game
# it includes:
#	- Scoring
#	- Organising game
#	- testing winning or losing

var Player: Node2D
var AI: Node2D
var GRID: Node2D
var menu
var HUD
var end_screen


var score_player = 0
var score_opponent = 0


func _ready() -> void:
	randomize()
	Player = get_node("Player")
	AI = get_node("AI")
	GRID = get_node("Grid")
	GRID.connect("Draw", draw)
	Player.connect("Played", switch_AI)
	AI.connect("Played", switch_Player)
	menu = get_node("UI/Menu")
	HUD = get_node("UI/HUD")
	end_screen = get_node("UI/EndScreen")

func win(value):
	if int(Player.first) == value:
		end_screen.update_text("Won")
		score_player += 1
	else:
		end_screen.update_text("Lost")
		score_opponent += 1
	HUD.update_wins(score_player, score_opponent)
	end_screen.visible = true
	GRID.play = false

func draw():
	end_screen.visible = true
	GRID.play = false
	end_screen.update_text("Draw")


func switch_AI():
	if GRID.test_win():
		return
	if GRID.test_end():
		return
	Player.can_play = false
	AI.play()

func switch_Player():
	if GRID.test_win():
		return
	if GRID.test_end():
		return
	Player.can_play = true

func _on_menu_play(first) -> void:
	score_player = 0
	score_opponent = 0
	menu.visible = false
	HUD.visible = true
	HUD.update_wins(0, 0)
	HUD.play_as(first)
	GRID.visible = true
	GRID.play = true
	Player.first = not first
	AI.first = first
	if first:
		switch_AI()
	else:
		switch_Player()


func restart() -> void:
	GRID.clear()
	GRID.play = true
	end_screen.visible = false
	if Player.first:
		switch_Player()
	else:
		switch_AI()

func end_game() -> void:
	GRID.clear()
	GRID.visible = false
	GRID.play = false
	HUD.visible = false
	menu.visible = true
	end_screen.visible = false
