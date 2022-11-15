extends AudioStreamPlayer3D

onready var left_foot_sound = [preload("res://sounds/steps/left_1.wav"), preload("res://sounds/steps/left_2.wav"), preload("res://sounds/steps/left_3.wav")]
onready var right_foot_sound = [preload("res://sounds/steps/right_1.wav"), preload("res://sounds/steps/right_2.wav"), preload("res://sounds/steps/right_3.wav")]

var prev_rand = randi() % 3

func _on_Camera_footstep(left):
	var new_rand = randi() % 3
	if new_rand == prev_rand:
		new_rand = (new_rand + 1) % 3
	prev_rand = new_rand
	
	if left:
		stream = left_foot_sound[new_rand]
		play()
	else:
		stream = right_foot_sound[new_rand]
		play()
