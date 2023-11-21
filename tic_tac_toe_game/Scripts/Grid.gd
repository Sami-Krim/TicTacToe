extends Node2D
class_name Grid
# game grid, here the game goes 
# drawing the grid in tic tac toe game, 
# and testing if there is a winner or a draw


#signals
signal Win(value)
signal Draw

var GRID = [
	[-1, -1, -1], 
	[-1, -1, -1], 
	[-1, -1, -1]
]

var sprites = [preload("res://Assets/O.png"), preload("res://Assets/X.png")]
var play = false
func add_element(value, pos) -> int:
	if not play: return 0
	#returns 1 if insertion successful, else 0
	if GRID[pos.y][pos.x] != -1: return 0
	else: 
		GRID[pos.y][pos.x] = value
	draw_changes(sprites[value], pos)
	return 1

func draw_changes(tex, pos):
	var sprite = Sprite2D.new()
	sprite.texture = tex
	sprite.scale /= 3.0
	sprite.position = pos * 200 + Vector2i(100, 100)
	add_child(sprite)

func test_row():
	for i in range(3):
		if GRID[i][0] == GRID[i][1] and GRID[i][1] == GRID[i][2] and GRID[i][1] != -1:
			return GRID[i][0]
	return false

func test_col():
	for i in range(3):
		if GRID[0][i] == GRID[1][i] and GRID[1][i] == GRID[2][i] and GRID[1][i] != -1:
			return GRID[0][i]
	return false

func test_diag():
	if ((GRID[0][0] == GRID[1][1] and GRID[1][1] == GRID[2][2]) or (GRID[0][2] == GRID[1][1] and GRID[1][1] == GRID[2][0])) and GRID[1][1] != -1:
		return GRID[1][1]
	return false

func test_win():
	var row = test_row()
	var col = test_col()
	var diag = test_diag()
	if row is int:
		emit_signal("Win", row)
		return true
	elif col is int:
		emit_signal("Win", col)
		return true
	elif diag is int:
		emit_signal("Win", diag)
		return true
	return false

func test_end():
	for i in range(3):
		for j in range(3):
			if GRID[i][j] == -1: return false
	emit_signal("Draw")
	return true

func clear():
	for i in range(3):
		for j in range(3):
			GRID[i][j] = -1
	for i in range(1, get_child_count()):
		var c = get_child(i)
		if is_instance_of(c, Sprite2D):
			c.queue_free()
