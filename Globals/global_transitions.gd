extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func fade():
	animation_player.play("Fade")
	await animation_player.animation_finished

func unfade():
	animation_player.play("Unfade")
	await animation_player.animation_finished

func transition_to(scene:String):
	await fade()
	get_tree().change_scene_to_file(scene)
	unfade()
