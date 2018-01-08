extends KinematicBody2D

onready var SFX = get_node("SFX")

var dir = Vector2(0,-1)

var speed = 180


func reset():
	set_fixed_process(false)
	
	
	

func go():
	dir = Vector2( rand_range( -0.25, 0.25 ), -1 )
	set_fixed_process(true)



func _fixed_process(delta):
	# Clamp vertical velocity. Keeps the ball from going too "horizontal"
	dir.y = 80 * sign( dir.y )
	
	# Move in the direction at speed
	var motion = move( dir.normalized() * speed * delta )
	
	# Collision Handling
	if is_colliding():
		var col = get_collider()
		
		# SFX/Animation triggers
		if col extends TileMap:
			SFX.play( "ping_brick" )
		elif col.is_in_group( "PADDLE" ):
			SFX.play( "ping_paddle" )
			col.get_node( "Animator").play( "bump" )
		else:
			SFX.play("ping_wall")
			
		# Get Brick map colliding cell (when hitting bricks)
		var m = get_collider_metadata()
		if typeof(m) == TYPE_VECTOR2:
			# If we hit a brick..
			get_node("/root/Main").on_Ball_hit_brick( m )
		
		#Recalculate direction when we bounce
		var n = get_collision_normal()
		if col.is_in_group("PADDLE"):
			var x_diff = get_pos().x - col.get_pos().x
			dir = Vector2( x_diff * 5, -1 )
		else:
			dir = n.reflect( dir )


