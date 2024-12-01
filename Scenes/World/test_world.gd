extends Node2D

class_name BaseLevel

@onready var figures = $Figures


@export var progression_amount:int = 0

@export var own_path: String
#PLAYER
@export var video_player :AnimationPlayer
@onready var video_slider = %VideoSlider

@onready var texture_rect = $UI/TextureRect

@onready var play_button = %PlayButton
@onready var pause_button = %PauseButton
@onready var choice_button = %ChoiceButton

@onready var pause_screen = $PauseScreen

@onready var unpause_button = %"Unpause Button"
@onready var options_button = %"Options Button"
@onready var quit_button = %"Quit Button"

@onready var target_cursor = $TargetCursor

@onready var time_progress_bar = %TimeProgressBar
@onready var time_limit = $TimeLimit

@onready var level_end = $LevelEnd


const LOW_TIME_PROGRESS_BAR = preload("res://Resources/Sprites/UI/Player/LowTimeProgressBar.png")

#SFX
@onready var play_pause = $PlayPause


var playing: bool = true:
	set(value):
		
		if playing != value:
			play_pause.play()
		
		playing = value
		
		if not readied:
			await ready
		
		
		if value == true:
			play_button.disabled = true
			pause_button.disabled = false
		
		else:
			play_button.disabled = false
			pause_button.disabled = true

var readied: bool = false

var time_low: bool = false

var hovered: HurtBox

var marked: Hoverable

var decision_ready: bool = false
var choosing:bool = false:
	set(value):
		if value:
			
			var tween:Tween = create_tween()
			tween.tween_property(texture_rect, "modulate", Color(0.5, 0.5, 0.5), 0.5)
			
			play_button.disabled = true
			pause_button.disabled = true
			choice_button.disabled = true
			options_button.disabled = true
			
			video_slider.editable = false
			
			playing = false
			
			var tween2: Tween = create_tween()
			await tween2.tween_property(video_slider, "value", video_slider.max_value, 0.8)\
			.set_trans(Tween.TRANS_CIRC).finished
			
			decision_ready = true
		else:
			var tween:Tween = create_tween()
			tween.tween_property(texture_rect, "modulate", Color.WHITE, 0.5)
		choosing = value

var slider_amount:float = 0

func _ready():
	get_viewport().physics_object_picking_sort = true
	get_viewport().physics_object_picking_first_only = true
	
	if video_player != null:
		video_player.play("Video")
		video_player.pause()
	
	GlobalMusic.change_music_to("Base Music")
	
	readied = true

func _process(_delta):
	handle_time()
	handle_esc()
	handle_spc()
	
	handle_hover()
	handle_click()
	update_slider()

func handle_time():
	if not time_limit.is_stopped():
		time_progress_bar.value = (time_limit.time_left / time_limit.wait_time) * 170
		
		if time_limit.time_left < 15 and not time_low:
			time_low = true
			GlobalMusic.change_music_to("Urgent")
			$UI/AnimationPlayer.play("LowTime")

func handle_esc():
	if Input.is_action_just_pressed("Esc"):
		#PAUSE
		pause_screen.visible = true
		get_tree().paused = true

func handle_spc():
	if Input.is_action_just_pressed("SpaceBar"):
		if not playing:
			video_player.play()
			playing = true
		elif playing:
			video_player.pause()
			playing = false

func handle_hover():
	if choosing:
		target_cursor.global_position = get_global_mouse_position()
	
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	
	var space = get_world_2d().direct_space_state
	
	var result = space.intersect_point(query)
	
	var r_bodies: Array[HurtBox]
	
	#find all bodies at the position of the mouse
	if not result.is_empty():
		
		
		for bod in result:
			if bod["collider"] is HurtBox:
				r_bodies.append(bod["collider"])
		#print(r_bodies)
		#print(result[0]["collider"])
	
	var r_lowest: HurtBox
	var lowest_val :float = -999999999999.9
	
	#find the body that is "in front"
	for bod in r_bodies:
		if bod is HurtBox:
			if lowest_val == null:
				r_lowest = bod
				lowest_val = bod.hurt_owner.global_position.y
				
			elif bod.hurt_owner.global_position.y > lowest_val:
				r_lowest = bod
				lowest_val = bod.hurt_owner.global_position.y
	
	if r_lowest != null:
		if r_lowest.hurt_owner.unselectable:
			r_lowest = null
	
	#outline correct body
	if hovered != r_lowest:
		if hovered != null:
			hovered.hurt_owner.hide_outline()
		if r_lowest != null:
			r_lowest.hurt_owner.show_outline()
		
		hovered = r_lowest

func handle_click():
	if choosing:
		if decision_ready and Input.is_action_just_pressed("LeftClick"):
			#print("decision")
			if hovered != null and hovered.hurt_owner is Hoverable:
				if hovered.hurt_owner.is_assassin:
					
					if progression_amount > Globals.progression:
						Globals.progression = progression_amount
						#SAVE
						Globals.save_data()
					
					end_level(true)
				else:
					end_level(false)
		
		
	elif Input.is_action_just_pressed("RightClick"):
		if hovered != null:
			if not hovered.hurt_owner.unselectable:
				if marked != hovered.hurt_owner:
					if marked != null:
						if marked.is_marked:
							marked.toggle_mark()
							marked.hide_outline()
					
					marked = hovered.hurt_owner
				
				hovered.hurt_owner.toggle_mark()

func update_slider():
	if playing and video_player.current_animation == "Video":
		video_slider.value = 100 * \
		(video_player.current_animation_position / video_player.current_animation_length )


func _on_timer_timeout():
	time_limit.start()
	video_player.play("Video")
	video_player.seek(0)
	choice_button.disabled = false
	playing = true


func _on_video_slider_value_changed(value):
	if not playing:
		if abs(slider_amount - value) > 8:
			slider_amount = value
			$SliderTick.pitch_scale = randf_range(0.8, 1)
			$SliderTick.play()
		var percent = value/100
		video_player.seek(video_player.current_animation_length * percent, true)

func _on_video_slider_drag_started():
	video_player.pause()
	playing = false

func _on_play_button_pressed():
	if not playing:
		video_player.play()
		playing = true

func _on_pause_button_pressed():
	if playing:
		video_player.pause()
		playing = false

func _on_video_player_animation_started(_anim_name):
	playing = true

func _on_video_player_animation_finished(_anim_name):
	playing = false

func _on_video_slider_mouse_exited():
	video_slider.release_focus()

func _on_unpause_button_pressed():
	#UNPAUSE
	pause_screen.visible = false
	get_tree().paused = false

func _on_gear_button_pressed():
	#PAUSE
	pause_screen.visible = true
	get_tree().paused = true

func _on_choice_button_pressed():
	if choosing:
		choosing = false
		target_cursor.visible = false
	else:
		$ChoiceButtonSound.play()
		choosing = true
		target_cursor.visible = true

func _on_time_limit_timeout():
	end_level(false)

func end_level(correct: bool):
	time_limit.paused = true
	level_end.visible = true
	level_end.play_end(correct)


func _on_options_button_pressed():
	var OPTIONS_MENU = load("res://Scenes/Menus/options_menu.tscn")
	var inst = OPTIONS_MENU.instantiate()
	add_child(inst)


func _on_level_end_level_select():
	GlobalTransitions.transition_to("res://Scenes/Menus/level_select.tscn")


func _on_level_end_restart():
	GlobalTransitions.transition_to(own_path)


func _on_quit_button_pressed():
	get_tree().paused = false
	GlobalTransitions.transition_to("res://Scenes/Menus/level_select.tscn")
