extends KinematicBody2D

onready var BallCatch = get_node("BallCatch")

onready var y = get_pos().y

var speed = 130

func has_ball():
	return BallCatch.get_child_count() > 0

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
	var L = Input.is_action_pressed("paddle_left")
	var R = Input.is_action_pressed("paddle_right")
	var FIRE = Input.is_action_pressed("fire")

	var motion = Vector2( (R-L)*speed*delta, 0 )
	move(motion)
	
	if get_pos().y != self.y:
		set_pos( Vector2( get_pos().x, self.y ) )
	
	if FIRE and has_ball():
		launch_ball()