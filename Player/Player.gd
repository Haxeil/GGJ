extends KinematicBody2D

var gravity = 12
var speed = 300
var velocity = Vector2.ZERO
onready var ground_ray = $Ray
onready var ray_vector = ground_ray.cast_to

func _physics_process(dt):
	apply_gravity(dt);
	move()

func _process(delta):
	adjust_movement()

func apply_gravity(dt):
	if ground_ray.is_colliding():
		velocity = Vector2(cos(rotation), sin(rotation)) * speed
		if rotation == 0:
			velocity.y = 0
	else:
		velocity.y += gravity;

func move():

	move_and_slide(velocity, ray_vector)

func adjust_movement():
	if ground_ray.is_colliding():
		var normal_vec = ground_ray.get_collision_normal()
		var adjustment_angle = -normal_vec.angle_to(-ray_vector)
		if abs(adjustment_angle) >= deg2rad(80): return
		var tween = get_tree().create_tween()
		tween.tween_property(self, "rotation", adjustment_angle, 0.3)


	
	
	



func _on_Area2D_area_entered(area):
	if area.is_in_group("Coin"):
		area.queue_free()
		$"../UI/CoinCount".text = str(int($"../UI/CoinCount".text)+1)
