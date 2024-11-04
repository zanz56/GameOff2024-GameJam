extends CharacterBody2D

class_name figure

signal create_projectile(pr: Projectile)

const PROJECTILE = preload("res://Scenes/Projectiles/projectile.tscn")

@onready var animation_player = $AnimationPlayer


@onready var aim = $Aim

@onready var hurtbox = $Hurtbox

@onready var body_sprite = $VisualNode/BodySprite

@export var player_char: bool = false
@export var char_color: Color = Color.WHITE

@export var Player_Shot_speed: float = 20.0

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


func shoot(multip: int):
	var pro_inst = PROJECTILE.instantiate()
	pro_inst.Creator = self
	
	var temp: Vector2 = Vector2.RIGHT.rotated(aim.rotation)
	#var temp: Vector2 = aim.target_position.normalized()
	
	pro_inst.velocity = temp * multip
	
	pro_inst.global_position = aim.global_position
	
	create_projectile.emit(pro_inst)
