extends KinematicBody2D


var gravity = 12
var speed = 300
var velocity = Vector2.ZERO
onready var ground_ray = $GroundDetection/Ray00
onready var ray_vector = ground_ray.cast_to
var jump_power = speed
var was_on_ground: bool = false
var on_ground = false
var jump_vector = Vector2.UP
var gravity_vector = Vector2.DOWN
onready var animation_sprite: AnimatedSprite = $AnimatedSprite
onready var animation_coin: AnimatedSprite = $CoinAnim

var rotation_adjustment_speed = PI / 12 # 1/12 rotation 

func _ready():
	for child in $GroundDetection.get_children():
		var ray: RayCast2D = child
		ray.add_exception(self)

func _physics_process(dt):
	apply_gravity(dt);
	jump()
#	set_veloity_length()
	move()

func _process(delta):
	adjust_movement()

func apply_gravity(dt):
	if on_ground:
		animation_sprite.play("Idle")
		if $Slide.playing == false:
			$Slide.play()
		if rotation == 0:
			velocity.y = 0
	else:
		velocity -= gravity * gravity_vector;
		if velocity.length() != 0 and velocity.length() > gravity_vector.length() and velocity.length() > -jump_vector.length() / gravity_vector.length():
			if animation_sprite.animation == "Jump" and animation_sprite.playing == true: return
			animation_sprite.play("Fall")
			$Slide.stop()
		
		
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
	
	if was_on_ground == false and on_ground:
		if not $Hit.playing == true:
			$Hit.play()

func adjust_movement():
	if on_ground:
		var normal_vec = ground_ray.get_collision_normal()
		var adjustment_angle = -normal_vec.angle_to(-ray_vector)
		if abs(adjustment_angle) >= deg2rad(80): return
		var tween = get_tree().create_tween()
		tween.tween_property(self, "rotation", adjustment_angle, 0.3)


func jump():
	if Input.is_action_just_pressed("jump") and on_ground: 
		animation_sprite.play("Jump")
		$Slide.stop()
		$Jump.play()
		$Jump1.play()
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
	if rotation < 0:
		rotation += rotation_adjustment_speed * dt
	elif rotation > 0:
		rotation -= rotation_adjustment_speed * dt

func _on_Area2D_area_entered(area):
	if area.is_in_group("Coin"):
		animation_coin.play("none")
		area.queue_free()
		$"../UI/CoinCount".text = str(int($"../UI/CoinCount".text)+1)
		animation_coin.play("default")
		

func _on_AnimatedSprite_animation_finished():
	if animation_sprite.animation == "Jump":
		animation_sprite.play("Fall")
		#reset speed
		speed = 300

func _on_IncreaseSpee_timeout():
	speed += 4
	jump_power = speed
