extends BaseLevel

@onready var tutorial = $UI/Tutorial
@onready var timer = $Timer

func _on_tutorial_close_pressed():
	
	tutorial.visible = false
	
	timer.start()
	video_player.play("RESET")
	
	#allows for button sound to finish
	await get_tree().create_timer(0.4).timeout
	
	tutorial.queue_free()
