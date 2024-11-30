extends Control

@onready var tutorial_level_button_1 = $Buttons/VBoxContainer/HBoxContainer/TutorialLevelButton1
@onready var tutorial_level_button_2 = $Buttons/VBoxContainer/HBoxContainer/TutorialLevelButton2

@onready var level_button_1 = $Buttons/VBoxContainer/HBoxContainer2/LevelButton1

@onready var menu_button = $Buttons/VBoxContainer/MarginContainer/MenuButton

const MAIN_MENU = "res://Scenes/Menus/main_menu.tscn"

# levels
# T1: press button, target obivous assassin
# T2: rewind, play, pause, 
# T3: time limit, marking, mark 2 same characters to see which one has a weapon

func _ready():
	if Globals.progression < 2:
		level_button_1.disabled = true
	if Globals.progression < 1:
		tutorial_level_button_2.disabled = true
		pass
	
	GlobalTransitions.unfade()


func _on_menu_button_pressed():
	GlobalTransitions.transition_to(MAIN_MENU)


func _on_tutorial_level_button_1_pressed():
	GlobalTransitions.transition_to("res://Scenes/World/tutorial_1.tscn")


func _on_tutorial_level_button_2_pressed():
	GlobalTransitions.transition_to("res://Scenes/World/tutorial_2.tscn")


func _on_level_button_1_pressed():
	GlobalTransitions.transition_to("res://Scenes/World/level_1.tscn")
