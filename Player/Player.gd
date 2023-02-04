extends KinematicBody2D


var gravity = 12
var speed = 300
var velocity = Vector2.ZERO
onready var ground_ray = $GroundDetection/Ray00
onready var ray_vector = ground_ray.cast_to
export var jump_power = 300
var was_on_ground = false
var on_ground = false
var jump_vector = Vector2.UP
var gravity_vector = Vector2.DOWN

var rotation_adjustment_speed = PI / 6 # 1/12 rotation 

func _physics_process(dt):
	apply_gravity(dt);
	jump()
#	set_veloity_length()
	move()

func _process(delta):
	adjust_movement()

func apply_gravity(dt):
	if on_ground:
		if rotation == 0:
			velocity.y = 0
	else:
		velocity -= gravity * gravity_vector;
		adjust_rotation_when_flying(dt)

func move():
	if on_ground:
		velocity = Vector2(cos(rotation), sin(rotation)) * speed
		# perpendicular Counter clockwise
		jump_vector = Vector2(-velocity.normalized().y, velocity.normalized().x)
		# perpendicular Clockwise
		gravity_vector = Vector2(velocity.normalized().y, -velocity.normalized().x)
		
	was_on_ground = on_ground
	move_and_slide(velocity, ray_vector)
	on_ground = check_ground_collision()

func adjust_movement():
	if on_ground:
		var normal_vec = ground_ray.get_collision_normal()
		var adjustment_angle = -normal_vec.angle_to(-ray_vector)
		if abs(adjustment_angle) >= deg2rad(80): return
		var tween = get_tree().create_tween()
		tween.tween_property(self, "rotation", adjustment_angle, 0.3)


func jump():
	if Input.is_action_just_pressed("jump") and on_ground: 
		for ray in $GroundDetection.get_children():
			ray.enabled = false
		$JumpTime.start()
		on_ground = false
		velocity += jump_vector * -jump_power



func _on_JumpTime_timeout():
	for ray in $GroundDetection.get_children():
		ray.enabled = true


func check_ground_collision() -> bool:
	
	for ray in $GroundDetection.get_children():
		if ray.is_colliding():
			return true
		
	return false

func adjust_rotation_when_flying(dt):
	if rotation < velocity.angle_to(gravity_vector):
		rotation -= rotation_adjustment_speed * dt
	elif rotation > velocity.angle_to(gravity_vector):
		rotation += rotation_adjustment_speed * dt

func _on_Area2D_area_entered(area):
	if area.is_in_group("Coin"):
		area.queue_free()
		$"../UI/CoinCount".text = str(int($"../UI/CoinCount".text)+1)
