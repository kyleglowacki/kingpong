extends CharacterBody2D

var W_BOTTOM = 815
var W_TOP = 0
var PADDLE_HEIGHT = 260

func _ready():
	pass

func set_paddle_position(x, y):
	if y <= W_TOP:
		y = 1
	if y >= W_BOTTOM - PADDLE_HEIGHT:
		y = W_BOTTOM - 1 - PADDLE_HEIGHT
	self.position = Vector2(x, y)
