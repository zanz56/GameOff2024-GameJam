extends BaseLevel

@onready var tutorial = $UI/Tutorial
@onready var timer = $Timer

func _on_tutorial_close_pressed():
	timer.start()
	video_player.play("RESET")
	tutorial.queue_free()
