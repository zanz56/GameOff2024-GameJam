extends CharacterBody2D

class_name figure

signal create_projectile(pr: Projectile)

const PROJECTILE = preload("res://Scenes/Projectiles/projectile.tscn")

@onready var animation_player = $AnimationPlayer


@onready var aim = $Aim

@onready var hurtbox = $Hurtbox

@onready var body_sprite = $VisualNode/BodySprite
@onready var head_sprite = $VisualNode/HeadSprite

@onready var outline_creator = $OutlineCreator
@onready var outline_body = $OutlineCreator/OutlineBody
@onready var outline_head = $OutlineCreator/OutlineHead

@export var player_char: bool = false
@export var char_color: Color = Color.WHITE

@export var Player_Shot_speed: float = 20.0

@export var is_protect_target: bool = false

func _ready():
	if player_char:
		body_sprite.modulate = Color(0.114, 0.188, 0.796)
		
	else:
		body_sprite.modulate = char_color

func _process(_delta):
	
	if player_char:
		
		aim.look_at(get_global_mouse_position())
		
		if Input.is_action_just_pressed("LeftClick"):
			shoot(Player_Shot_speed)
		
		var horiz_move = Input.get_axis("Left", "Right")
		var vert_move = Input.get_axis("Up", "Down")
		var direction :Vector2 = Vector2(horiz_move, vert_move).normalized()
		velocity = direction * 200
		
	
	else:
		velocity = Vector2.ZERO
	
	
	if abs(velocity.x) > abs(velocity.y):
		if velocity.x > 0:
			animation_player.play("WalkRight")
		elif velocity.x < 0:
			animation_player.play("WalkLeft")
	
	elif abs(velocity.x) <= abs(velocity.y):
		if velocity.y > 0:
			animation_player.play("WalkDown")
		elif velocity.y < 0:
			animation_player.play("WalkUp")
	
	if velocity == Vector2.ZERO:
		animation_player.play("Spin")
	
	
	move_and_slide()


func shoot(multip: float):
	var pro_inst = PROJECTILE.instantiate()
	pro_inst.Creator = self
	
	var temp: Vector2 = Vector2.RIGHT.rotated(aim.rotation)
	#var temp: Vector2 = aim.target_position.normalized()
	
	pro_inst.velocity = temp * multip
	
	pro_inst.global_position = aim.global_position
	
	create_projectile.emit(pro_inst)

func _on_body_sprite_frame_changed():
	outline_body.frame = body_sprite.frame

func _on_head_sprite_frame_changed():
	outline_head.frame = head_sprite.frame

func show_outline():
	outline_creator.visible = true

func hide_outline():
	outline_creator.visible = false

func _on_hurtbox_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		print(self)
