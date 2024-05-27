extends RigidBody2D

# Ball moves at 'speed'.  Direction of movement is from dx,dy unit vector.
# dx*dx + dy*dy = 1
# To keep ball moving back and forth magnitude of dx must be at least 0.2
var dx = 0
var dy = 0
var speed = 150
var playing = false

var MAX_SPEED = 500

var W_TOP = 0
var W_BOTTOM = 815
var BALL_SIZE = 15

# Value is either -1 or +1
var direction = 1


func _ready():
	pass


func _physics_process(delta):
	if playing:
		change_dy_on_wall_hit()
		self.rotation = 0
		self.linear_velocity = Vector2(dx*100, dy*100) * delta * speed

func _ball_hit_paddle(_body):
	self.direction *= -1
	self.dy = randf_range(-1.0, 1.0)
	# Figure out dx 
	self.dx = sqrt(1.0 - (self.dy * self.dy)) * self.direction
	
	# Keep accelerating
	if self.speed < MAX_SPEED:
		self.speed += 5
	$PaddleHitSound.play()


func change_dy_on_wall_hit():
	if self.position.y <= W_TOP:
		dy = -self.dy
	if self.position.y >= W_BOTTOM - BALL_SIZE:
		dy = -self.dy


func set_playing(_playing):
	self.dy = randf_range(-1.0, 1.0)
	# Figure out dx 
	self.dx = sqrt(1.0 - (self.dy * self.dy)) * self.direction
	self.playing = _playing
