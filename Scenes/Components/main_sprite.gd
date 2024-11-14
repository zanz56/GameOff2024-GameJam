extends Sprite2D
class_name MainSprite

@export var duplicated_sprite: Sprite2D

func _process(_delta):
	if duplicated_sprite != null:
		duplicated_sprite.global_position = global_position

func _on_frame_changed():
	if duplicated_sprite != null:
		duplicated_sprite.frame = frame

func _on_texture_changed():
	if duplicated_sprite != null:
		duplicated_sprite.texture = texture

func _on_visibility_changed():
	if duplicated_sprite != null:
		if visible:
			duplicated_sprite.visible = true
		else:
			duplicated_sprite.visible = false
