extends Node2D

@onready var player_figure = $Figures/PlayerFigure
@onready var projectiles = $Projectiles
@onready var figures = $Figures

var hovered: HurtBox
# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().physics_object_picking_sort = true
	get_viewport().physics_object_picking_first_only = true
	
	
	
	for f:figure in figures.get_children():
		
		f.connect("create_projectile", add_projectile)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#RenderingServer.CANVAS_ITEM_Z_MAX
	
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	
	var space = get_world_2d().direct_space_state
	
	var result = space.intersect_point(query)
	
	var r_bodies: Array[HurtBox]
	
	#find all bodies at the position of the mouse
	if not result.is_empty():
		
		
		for bod in result:
			if bod["collider"] is HurtBox:
				r_bodies.append(bod["collider"])
		#print(r_bodies)
		#print(result[0]["collider"])
	
	var r_lowest: HurtBox
	var lowest_val :float = -999999999999.9
	
	#find the body that is "in front"
	for bod: HurtBox in r_bodies:
		
		if lowest_val == null:
			r_lowest = bod
			lowest_val = bod.hurt_owner.global_position.y
			
		elif bod.hurt_owner.global_position.y > lowest_val:
			r_lowest = bod
			lowest_val = bod.hurt_owner.global_position.y
			
	
	#outline correct body
	if hovered != r_lowest:
		if hovered != null:
			hovered.hurt_owner.hide_outline()
		if r_lowest != null:
			r_lowest.hurt_owner.show_outline()
		
		hovered = r_lowest

func add_projectile(pr: Projectile):
	projectiles.add_child(pr)


func _on_timer_timeout():
	print(".")
