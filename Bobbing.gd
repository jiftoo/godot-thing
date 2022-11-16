extends Camera

onready var hinge_object = $"../../CameraHinge"

onready var time_since_start = 0
onready var initial_translation_y = hinge_object.translation.y

var bob_counter = 0

signal footstep(left)
var left_foot = true # false - right foot

var played_stop_step = true

func _process(delta):
	var move_speed = $"/root/Spatial/Player".get("current_speed")
	bob_counter += (move_speed/6.0 + 1) * delta
	hinge_object.translation.y = initial_translation_y + (sin(bob_counter) + 2) * (0.05 + 0) #0.004 * move_speed
	
	if move_speed > 0:
		played_stop_step = false
		if left_foot and cos(bob_counter) >= 0:
			emit_signal("footstep", left_foot)
			left_foot = false
		if !left_foot and cos(bob_counter) <= 0:
			emit_signal("footstep", left_foot)
			left_foot = true
	elif !played_stop_step:
		emit_signal("footstep", left_foot)
		played_stop_step = true
