extends KinematicBody2D

var gravity = 12
var speed = 40
var velocity = Vector2.ZERO
onready var ground_ray = $Ray
onready var ray_vector = ground_ray.cast_to

func _physics_process(dt):
	apply_gravity(dt);
	move()


func apply_gravity(dt):
	if ground_ray.is_colliding():
		velocity.y = 0
	else:
		velocity.y += gravity;

func move():
	velocity.x = speed;
	move_and_slide(velocity, Vector2.UP)
	if ground_ray.is_colliding():
		var normal_vec = ground_ray.get_collision_normal()
		if normal_vec.cross(ray_vector) == 0: return
		var adjustment_angle = -normal_vec.angle_to(-ray_vector)
		if abs(adjustment_angle) >= deg2rad(80): return
		var tween = get_tree().create_tween()
		tween.tween_property(self, "rotation", adjustment_angle, 0.3)


