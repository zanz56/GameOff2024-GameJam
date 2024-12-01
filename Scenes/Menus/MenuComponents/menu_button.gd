extends Button

@onready var button_down_sound = $ButtonDownSound
@onready var button_up_sound = $ButtonUpSound
@onready var timer = $Timer

@export var plays_sound: bool = true

func _on_button_down():
	if plays_sound:
		button_down_sound.play()


func _on_button_up():
	if plays_sound:
		if button_down_sound.playing:
			timer.start()
			await timer.timeout
		button_up_sound.play()
