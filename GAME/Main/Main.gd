extends Node2D

signal game_over()
signal clear_stage()

onready var Paddle = get_node("Paddle")

onready var Bricks = get_node("Bricks")
onready var Lives = get_node("Lives")
onready var SFX = get_node("SFX")

# Player score. Updates display when set
var score = 0 setget _set_score
# Player lives. Updates display when set
var extra_lives = 3 setget _set_extra_lives

# Spawn a new ball and stick it to the paddle
func reset_ball():
	var ball = preload("res://Parts/Ball.tscn").instance()
	Paddle.BallCatch.add_child(ball)
	ball.set_pos(Vector2(0,0))
	ball.add_to_group("BALL")
	print("RESET")
	
# Emits a signal if a stage is cleared
func check_for_win():
	var tiles_left = Bricks.get_used_cells().size()
	if tiles_left <= 0:
		emit_signal("clear_stage")

# Callback: Body (ball) enters the kill zone
func _on_KillZone_body_enter( body ):
	if body.is_in_group("BALL"):
		print("BALL DROPPED")
		SFX.play("kill")
		body.queue_free()
		self.extra_lives -= 1
		if self.extra_lives < 0:
			emit_signal("game_over")
		reset_ball()


# Called when a ball hits map cell where
func on_Ball_hit_brick( where ):
	# The tile ID of where
	var tid = Bricks.get_cellv( where )
	if tid == 6:
		# Silver brick turns to Lead
		Bricks.set_cellv( where, 7 )
	# All one-hit bricks..
	elif tid != -1:
		# Clear cell where
		Bricks.set_cellv( where, -1 )
	# Score some points!
	self.score += 10
	# Check for win after every hit brick
	check_for_win()

func _ready():
	# Randomize seed
	randomize()
	# Kickstart Lives display
	self.extra_lives = self.extra_lives

func _set_score(what):
	score = what
	print(score)
	get_node("Score").set_text( str(score).pad_zeros(4) )
	
	
func _set_extra_lives(what):
	extra_lives = what
	
	for node in Lives.get_children():
		node.queue_free()
	if extra_lives > 0:
		for i in range(extra_lives):
			var pip = TextureFrame.new()
			pip.set_texture( preload("res://assets/graphics/life_pip.png") )
			Lives.add_child(pip)
	
	