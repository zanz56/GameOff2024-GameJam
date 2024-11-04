extends Area2D

class_name Projectile

@export var velocity: Vector2 = Vector2.ZERO
var Creator: figure

func _process(delta):
	position += velocity * delta * 60


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	if area is HurtBox:
		if area.hurt_owner != Creator:
			queue_free()
