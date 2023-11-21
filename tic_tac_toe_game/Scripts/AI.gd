extends Node2D

#the AI plays as X if first else O
#X is always maximiser, O is always minimiser



signal Played

@onready var grid = get_parent().get_node("Grid")
@onready var timer = get_node("Timer")
@export var stupid = 0.0
var first = false

var root_state

func play():
	timer.start()

func _on_timer_timeout() -> void:
	var arr = find_best_move(grid.GRID, first)
	if arr[0] != -1:
		grid.add_element(int(first), Vector2i(arr[1], arr[0]))
	timer.wait_time = randf()+0.01
	emit_signal("Played")

func evaluate_board(state):
	#checks for any winning move
	#if there are then set the node to a leaf (can't have children)
	for i in range(3):
		var row = state[i]
		var col = [state[0][i], state[1][i], state[2][i]] 
		if row.count(1) == 3 or col.count(1) == 3:
			return 10
		elif row.count(0) == 3 or col.count(1) == 3:
			return -10

	var diag1 = [state[0][0], state[1][1], state[2][2]]
	var diag2 = [state[2][0], state[1][1], state[0][2]]
	if diag1.count(1) == 3 or diag2.count(1) == 3:
		return 10
	elif diag1.count(0) == 3 or diag2.count(1) == 3:
		return -10
	return 0

func is_draw(state):
	for i in range(3):
		for j in range(3):
			if state[i][j] == -1:
				return false
	return true

func minimax(state, depth, is_max):
	#evaluate the score of the current state
	var score = evaluate_board(state)
	#if it is a win or lose state, then return it's value
	if score == 10 or score == -10:
		return score - depth if score>0 else score + depth
	
	if is_draw(state):
		return 0
	#if it is maximiser, start from a minimum value and caluculate the values of the children to pick 
	#the highest value
	if is_max:
		var best = -1000
		for i in range(3):
			for j in range(3):
				#when finding an empty cell, fill it, evaluate its value and reset it 
				if state[i][j] == -1:
					state[i][j] = 1
					best = max(best, minimax(state, depth+1, false))
					state[i][j] = -1
		#finally return the best value (maximum in this case)
		return best

	else:
		#if the AI is minimiser, then do the same but pick the minimum value
		var best = 1000
		for i in range(3):
			for j in range(3):
				if state[i][j] == -1:
					state[i][j] = 0
					best = min(best, minimax(state, depth+1, true))
					state[i][j] = -1
		return best

func find_best_move(state, is_max):
	#finding the best move by trying all the possible combinations and picking the best one
	if is_max:
		var best_val = -1000
		var best_move = [-1, -1]
		for i in range(3):
			for j in range(3):
				if state[i][j] == -1:
					state[i][j] = 1
					var move_val = minimax(state, 0, false)
					if move_val >= best_val:
						best_val = move_val
						best_move = [i, j]
					state[i][j] = -1
		return best_move

	else:
		var best_val = 1000
		var best_move = [-1, -1]
		for i in range(3):
			for j in range(3):
				if state[i][j] == -1:
					state[i][j] = 0
					var move_val = minimax(state, 0, true)
					if move_val < best_val:
						best_val = move_val
						best_move = [i, j]
					state[i][j] = -1
		return best_move

