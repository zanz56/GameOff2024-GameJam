extends CanvasLayer

signal Restart
signal LevelSelect
signal Continue

@onready var animation_player = $AnimationPlayer

func _on_restart_button_pressed():
	Restart.emit()


func _on_l_select_button_pressed():
	LevelSelect.emit()


func _on_continue_button_pressed():
	Continue.emit()

func play_end(correct: bool):
	if correct:
		animation_player.play("CorrectChoice")
	else:
		animation_player.play("IncorrectChoice")
