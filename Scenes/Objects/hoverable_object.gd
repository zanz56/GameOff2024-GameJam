extends Node2D

class_name Hoverable


@onready var hurtbox = $Hurtbox

@onready var outline_creator = $OutlineCreator

@onready var visual_node = $VisualNode


@export var unselectable: bool = false
@export var is_protect_target: bool = false
@export var is_assassin: bool = false

var is_marked: bool = false

var is_ready: bool = false




func _ready():
	
	
	if is_protect_target:
		outline_creator.material.set_shader_parameter("line_colour", Color.GREEN)
		outline_creator.visible = true
	#for sprite: MainSprite in visual_node.get_children():
		#copy_sprite_to_outline(sprite)
	
	is_ready = true


func _on_visual_node_child_entered_tree(node):
	if not is_ready:
		await ready
	
	if node is MainSprite:
		copy_sprite_to_outline(node)
		node.duplicated_sprite.visible = node.visible
		
		if node.collision == null:
			var coll = CollisionPolygon2D.new()
			hurtbox.add_child(coll)
			node.collision = coll
			node.generate_collision()
		
		node.collision.disabled = not node.visible


func _on_visual_node_child_exiting_tree(node):
	if not is_ready:
		await ready
	
	if node is MainSprite:
		node.duplicated_sprite.queue_free()

func copy_sprite_to_outline(spr:MainSprite):
	var copy = Sprite2D.new()
	copy.global_position = spr.global_position
	copy.texture = spr.texture
	copy.hframes = spr.hframes
	copy.vframes = spr.vframes
	copy.frame = spr.frame
	#spr.duplicate()
	spr.duplicated_sprite = copy
	outline_creator.add_child(copy)

func add_sprite(texture: Texture, pos: Vector2, Hfra:int = 1, Vfra:int = 1, fra:int = 0):
	var spri = MainSprite.new()
	
	spri.texture = texture
	
	spri.hframes = Hfra
	spri.vframes = Vfra
	spri.frame = fra
	spri.global_position = visual_node.global_position + pos
	visual_node.add_child(spri)
	

func show_outline():
	if is_protect_target:
		outline_creator.material.set_shader_parameter("line_colour", Color.PALE_GREEN)
	elif is_marked:
		outline_creator.material.set_shader_parameter("line_colour", Color.PALE_VIOLET_RED)
	else:
		outline_creator.visible = true

func hide_outline():
	if is_protect_target:
		outline_creator.material.set_shader_parameter("line_colour", Color.GREEN)
	elif is_marked:
		outline_creator.material.set_shader_parameter("line_colour", Color.RED)
	else:
		outline_creator.visible = false

func toggle_mark():
	if not is_protect_target and not is_marked:
		outline_creator.material.set_shader_parameter("line_colour", Color.PALE_VIOLET_RED)
		is_marked = true
	elif is_marked:
		outline_creator.material.set_shader_parameter("line_colour", Color.WHITE)
		is_marked = false
