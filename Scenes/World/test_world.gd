extends Node2D

@onready var player_figure = $Figures/PlayerFigure
@onready var projectiles = $Projectiles


# Called when the node enters the scene tree for the first time.
func _ready():
	player_figure.connect("create_projectile", add_projectile)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func add_projectile(pr: Projectile):
	projectiles.add_child(pr)
