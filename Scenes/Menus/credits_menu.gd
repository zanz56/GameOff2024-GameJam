extends CanvasLayer
class_name Credits

@onready var quit_timer = $QuitTimer

func _on_menu_button_pressed():
	visible = false
	
	#allows for button sound to finish
	quit_timer.start()
	await quit_timer.timeout
	
	queue_free()
