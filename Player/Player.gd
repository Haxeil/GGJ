extends KinematicBody


var speed = 20
var velocity = Vector3.ZERO
var gravity = 15
var rotation_speed = PI / 5
var facing_direction = Vector3(1, 0, 0)

func _process(delta):
	handle_input(delta)

func _physics_process(delta):
	apply_gravity()
	move()
	move_and_slide(velocity, Vector3.UP)

func apply_gravity():
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y -= gravity

func handle_input(dt):
	if Input.is_action_pressed("right"):
		global_rotation.y -= rotation_speed * dt
	if Input.is_action_pressed("left"):
		global_rotation.y += rotation_speed * dt
	

func move():
	# no need for normalizing the Vector since cos and sin will give
	# values -1 < x < 1
	var direction = Vector3(cos(global_rotation.y), 0, -sin(global_rotation.y))
	
	velocity = direction * speed








