extends Sprite2D
class_name MainSprite

@export var duplicated_sprite: Sprite2D
@export var collision: CollisionPolygon2D

var sprite_size: Vector2
var is_ready: bool = false

func _ready():
	calculate_sprite_size()
	
	await generate_collision()
	
	is_ready = true
	
	

func _process(_delta):
	if duplicated_sprite != null:
		duplicated_sprite.global_position = global_position
		duplicated_sprite.flip_h = flip_h
		duplicated_sprite.flip_v = flip_v
		duplicated_sprite.scale = scale
		duplicated_sprite.rotation = rotation
	
	if collision != null:
		collision.position = position - (sprite_size/2)
	
	if Input.is_action_just_pressed("Right"):
		frame = (frame + 1) % 32

func _on_frame_changed():
	if not is_ready:
		await ready
	if duplicated_sprite != null:
		duplicated_sprite.frame = frame
	generate_collision()

func _on_texture_changed():
	if not is_ready:
		await ready
	if duplicated_sprite != null:
		duplicated_sprite.texture = texture
	generate_collision()

func _on_visibility_changed():
	if not is_ready:
		await ready
	if duplicated_sprite != null:
		if visible:
			duplicated_sprite.visible = true
			collision.disabled = false
		else:
			duplicated_sprite.visible = false
			collision.disabled = true

func generate_collision():
	
	if collision != null:
		var data: Image = texture.get_image()
		
		var bitmap = BitMap.new()
		bitmap.create_from_image_alpha(data)
		
		var polys = bitmap.opaque_to_polygons(
			Rect2(
				Vector2(sprite_size.x * frame,0),
				Vector2(sprite_size.x, sprite_size.y)
			)#,
			#decrese amount of detail
		)
		collision.position = position - (sprite_size/2)
		collision.polygon = polys[0]
		
		#print(polys[0])

func calculate_sprite_size():
	var sprite_size_t: Vector2 = texture.get_size()
	
	sprite_size_t.x = sprite_size_t.x / hframes
	sprite_size_t.y = sprite_size_t.y / vframes
	
	#print(sprite_size_t)
	
	sprite_size = sprite_size_t
