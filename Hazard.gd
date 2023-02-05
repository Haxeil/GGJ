extends Area2D




func _on_Hazard_body_entered(body):
	if body is KinematicBody2D:
		body.die()
