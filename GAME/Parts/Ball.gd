extends KinematicBody2D

onready var SFX = get_node("SFX")

var dir = Vector2(0,-1)

var speed = 160


func reset():
	set_fixed_process(false)
	
	
	

func go():
	dir = Vector2(0,-1)
	set_fixed_process(true)


func _ready():
	pass


func _fixed_process(delta):
	
	var motion = move( dir.normalized()*speed*delta )
	
	if is_colliding():
		var col = get_collider()
		if col extends TileMap:
			SFX.play("ping_brick")
		elif col.is_in_group("PADDLE"):
			SFX.play("ping_paddle")
			col.get_node("Animator").play("bump")
		else:
			SFX.play("ping_wall")
		var m = get_collider_metadata()
		if typeof(m) == TYPE_VECTOR2:
			# Hit a Brick!
#			prints("HIT BRICK ",m)
			get_node("/root/Main").on_Ball_hit_brick( m )
		var n = get_collision_normal()
		
		dir = n.reflect( dir )
#		move( motion )

