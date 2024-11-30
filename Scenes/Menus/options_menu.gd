extends CanvasLayer
class_name Settings
@onready var master_slider = %MasterSlider
@onready var sfx_slider = %SFXSlider
@onready var music_slider = %MusicSlider
@onready var fullscreen_toggle = %"Fullscreen Toggle"

@onready var nine_patch_rect = $NinePatchRect

var master_bus_index:int
var music_bus_index:int
var sfx_bus_index:int


func _ready():
	master_bus_index = AudioServer.get_bus_index("Master")
	music_bus_index = AudioServer.get_bus_index("Music")
	sfx_bus_index = AudioServer.get_bus_index("SFX")
	
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus_index))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_index))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_index))
	
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		fullscreen_toggle.button_pressed = false
	else:
		fullscreen_toggle.button_pressed = true


func _on_master_slider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(value))


func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_bus_index, linear_to_db(value))


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(value))


func _on_master_slider_mouse_exited():
	master_slider.release_focus()


func _on_sfx_slider_mouse_exited():
	sfx_slider.release_focus()


func _on_music_slider_mouse_exited():
	music_slider.release_focus()


func _on_quit_button_pressed():
	queue_free()


func _on_fullscreen_toggle_pressed():
	if fullscreen_toggle.button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
