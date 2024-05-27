extends Node2D

var BALL_NODE = preload("../Scenes/Ball.tscn")
var ball1 = BALL_NODE.instantiate()
var ball2 = BALL_NODE.instantiate()
var ball3 = BALL_NODE.instantiate()

const DEFAULT_Y = 150
var W_BOTTOM = 815
var W_WIDTH = 1215
var PADDLE_HEIGHT = 260
var PADDLE_WIDTH = 20

var EDGE = 15

const p1_x = 15
var p1_y = DEFAULT_Y
var p1_score = 0

# W_WIDTH - EDGE - PADDLE_WIDTH
const p2_x = 1180
var p2_y = DEFAULT_Y
var p2_score = 0

var playing = false
var score_event = false
var game_done = false

const SPACE_TO_PLAY = "Press SPACE to start the game!"
const P1_WIN = "Player 1 won!"
const P2_WIN = "Player 2 won!"
var message = SPACE_TO_PLAY

func _ready():
	ball1 = set_ball(ball1)
	$Player1.set_paddle_position(p1_x, p1_y)
	$Player2.set_paddle_position(p2_x, p2_y)
	display_message()
	update_score()


func _input(_event):
	if Input.is_key_pressed(KEY_SPACE):
		play()


func _process(delta):
	handle_movement_input(delta)
	$Player1.set_paddle_position(p1_x, p1_y)
	$Player2.set_paddle_position(p2_x, p2_y)
	check_point_scored()
	handle_score_event()
	handle_game_end()


func play():
	if game_done: # if game was done, reset states to start a fresh game
		game_done = false
		p1_score = 0
		p2_score = 0
		message = SPACE_TO_PLAY
		update_score()
	if not playing:
		playing = true
		ball1.set_playing(playing)
		$DisplayMessage.visible = false


func check_point_scored():
	if ball1.position.x <= EDGE:
		score_event = true
		p2_score += 1
	if ball1.position.x >= W_WIDTH - EDGE:
		score_event = true
		p1_score += 1
	update_score()
	if p1_score == 5 or p2_score == 5:
		game_done = true

func limit_movement_input():
	if p1_y < 0:
		p1_y = 0
	if p2_y < 0:
		p2_y = 0
	if p1_y > (W_BOTTOM - PADDLE_HEIGHT):
		p1_y = (W_BOTTOM - PADDLE_HEIGHT)
	if p2_y > (W_BOTTOM - PADDLE_HEIGHT):
		p2_y = (W_BOTTOM - PADDLE_HEIGHT)

func handle_movement_input(delta):
	if Input.is_key_pressed(KEY_W):
		p1_y -= 300 * delta
	if Input.is_key_pressed(KEY_S):
		p1_y += 300 * delta
	if Input.is_key_pressed(KEY_UP):
		p2_y -= 300 * delta
	if Input.is_key_pressed(KEY_DOWN):
		p2_y += 300 * delta
	limit_movement_input()

func handle_score_event():
	if score_event:
		remove_ball()
		ball1 = set_ball(ball1)
		reset_paddle_positions()
		display_message()
		playing = false
		score_event = false
		$ScoreSound.play()


func remove_ball():
	remove_child(ball1)


func set_ball(ball):
	ball = BALL_NODE.instantiate()
	add_child(ball)
	return ball


func reset_paddle_positions():
	p1_y = DEFAULT_Y
	p2_y = DEFAULT_Y


func update_score():
	$Player1Score.text = str(p1_score)
	$Player2Score.text = str(p2_score)


func handle_game_end():
	if game_done:
		if p1_score == 5:
			message = P1_WIN
		else:
			message = P2_WIN
		display_message()


func display_message():
	$DisplayMessage.text = message
	$DisplayMessage.visible = true
