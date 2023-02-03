extends KinematicBody


var speed = 20
var velocity = Vector3.ZERO
var gravity = 1
var rotation_speed = (PI / 5 ) * (speed / 20)
var facing_direction = Vector3(1, 0, 0)
var rotation_drag = 0.85

func _process(delta):
	handle_input(delta)

func _physics_process(delta):
	apply_gravity()
	move()
	move_and_slide(velocity, Vector3.UP)


func apply_gravity():
	if $FloorDetection.is_colliding():
		velocity.y = 0
	else:
		velocity.y -= gravity

func handle_input(dt):
	if Input.is_action_pressed("right"):
		global_rotation.y -= lerp(0, rotation_speed * dt, rotation_drag)
	elif Input.is_action_pressed("left"):
		global_rotation.y += lerp(0, rotation_speed * dt, rotation_drag)

func move():
	# no need for normalizing the Vector since cos and sin will give
	# values -1 < x < 1
	var direction = Vector3(cos(global_rotation.y), 0, -sin(global_rotation.y))
	
	velocity = Vector3(direction.x * speed, velocity.y, direction.z * speed)










func _on_IncreaseSpeed_timeout():
	speed += 2
