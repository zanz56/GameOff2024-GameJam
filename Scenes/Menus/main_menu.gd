extends Control

@onready var quit_button = $QuitButton
@onready var quit_color_rect = $NinePatchRect/ColorRect7
@onready var quit_color_rect2 = $NinePatchRect/ColorRect8

@onready var reticle_container = $TextureRect/ReticleContainer
@onready var marker_2d = $TextureRect/Marker2D

const LEVEL_SELECT = "res://Scenes/Menus/level_select.tscn"

func _ready():
	if OS.has_feature("web"):
		quit_button.disabled = true
	
	#LOAD
	Globals.load_data()

func _on_quit_button_pressed():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func _on_settings_button_pressed():
	var OPTIONS_MENU = load("res://Scenes/Menus/main_options_menu.tscn")
	var inst: Settings = OPTIONS_MENU.instantiate()
	add_child(inst)


func _on_start_game_button_pressed():
	var tween = create_tween()
	tween.tween_property(reticle_container, "global_position", marker_2d.global_position, 0.5)\
	.set_trans(Tween.TRANS_CIRC)
	#await get_tree().create_timer(0.)
	GlobalTransitions.transition_to(LEVEL_SELECT)


func _on_credits_button_pressed():
	var CREDITS_MENU = load("res://Scenes/Menus/credits_menu.tscn")
	var inst: Credits = CREDITS_MENU.instantiate()
	add_child(inst)
