extends Area2D

class_name Projectile

@export var velocity: Vector2 = Vector2.ZERO
var Creator: figure
var active: bool = true

func _process(delta):
	position += velocity * delta * 60


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if active:
		if body is HurtBox:
			if body.hurt_owner != Creator:
				active = false
				print("hit")
				#add hit
				pass
				queue_free()
		else:
			active = false
			queue_free()
