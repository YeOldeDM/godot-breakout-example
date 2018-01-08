extends KinematicBody2D

onready var BallCatch = get_node("BallCatch")

# Initial Y position. Used to keep the paddle
# vertically static
onready var y = get_pos().y

# Paddle movement speed
var speed = 150

# True if the ball is stuck to the paddle,
# ready to be "served"
func has_ball():
	return BallCatch.get_child_count() > 0

# Launches a ball that is stuck to the paddle
func launch_ball():
	var ball = BallCatch.get_child(0)
	var pos = ball.get_global_pos()
	BallCatch.remove_child(ball)
	get_parent().add_child(ball)
	ball.set_global_pos(pos)
	ball.call_deferred("go")

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	# Poll for input
	var L = Input.is_action_pressed("paddle_left")
	var R = Input.is_action_pressed("paddle_right")
	var FIRE = Input.is_action_pressed("fire")
	
	# Convert input to left/right movement
	var motion = Vector2( (R-L)*speed*delta, 0 )
	move(motion)
	
	# Keep the paddle from getting nudged out of its original Y position
	if get_pos().y != self.y:
		set_pos( Vector2( get_pos().x, self.y ) )
	
	# Serve the ball if we have one
	if FIRE and has_ball():
		launch_ball()





