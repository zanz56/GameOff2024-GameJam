extends Hoverable

@onready var coat_sprite = $VisualNode/CoatSprite
@onready var hat_sprite = $VisualNode/HatSprite
@onready var head_sprite = $VisualNode/HeadSprite

enum face_direction {UP, DOWN, LEFT, RIGHT}

@export var curr_dir: face_direction = face_direction.DOWN
@export var walk_frame: int:
	set(value):
		walk_frame = value % 6
		
		if not is_ready:
			await ready
		
		call_deferred("update_frame")

@export var HatHeight: int = -68

@export var Hat_Color:Color:
	set(value):
		Hat_Color = value
		update_colors()

@export var Coat_Color:Color:
	set(value):
		Coat_Color = value
		update_colors()




func _ready():
	if Coat_Color!= null:
		coat_sprite.modulate = Coat_Color
	
	if Hat_Color != null:
		hat_sprite.modulate = Hat_Color
	
	super()

func update_frame():
	#print("face_direction "+str(curr_dir))
	#print("frame "+str(walk_frame))
	var dire: int = 0
	
	match curr_dir:
		face_direction.UP:
			hat_sprite.frame = 3
			dire = 1
		face_direction.DOWN:
			hat_sprite.frame = 0
			dire = 0
		face_direction.LEFT:
			hat_sprite.frame = 2
			dire = 2
		face_direction.RIGHT:
			hat_sprite.frame = 1
			dire = 3
	 
	coat_sprite.frame = (dire * 6) + walk_frame
	head_sprite.frame = coat_sprite.frame
	
	match coat_sprite.frame % 6:
		0:
			hat_sprite.position = Vector2(0, HatHeight)
		1:
			hat_sprite.position = Vector2(0, HatHeight)
		2:
			hat_sprite.position = Vector2(0, HatHeight + 2)
		3:
			hat_sprite.position = Vector2(0, HatHeight + 6)
		4:
			hat_sprite.position = Vector2(0, HatHeight + 4)
		5:
			hat_sprite.position = Vector2(0, HatHeight + 2)

func update_colors():
	if not is_ready:
		await ready
	hat_sprite.modulate = Hat_Color
	coat_sprite.modulate = Coat_Color
