extends Node

@onready var audio_stream_player = $AudioStreamPlayer

var music: AudioStreamPlaybackInteractive

var current_music: String

func _ready():
	stop_music()
	music = audio_stream_player.get_stream_playback()

func change_music_to(track_name: String):
	if current_music != track_name:
		
		current_music = track_name
		
		music.switch_to_clip_by_name(track_name)
	
	if audio_stream_player.stream_paused:
		play_music()

func stop_music():
	audio_stream_player.stream_paused = true

func play_music():
	audio_stream_player.stream_paused = false

func fade_music():
	var tween:Tween = create_tween()
	tween.tween_property(audio_stream_player, "volume_db", -50, 1.5)
	await tween.finished
	stop_music()
	audio_stream_player.volume_db = 0


func _on_music_start_timer_timeout():
	GlobalMusic.change_music_to("Base Music")
