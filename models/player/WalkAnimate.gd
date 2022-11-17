extends Spatial

onready var animation_tree = $"AnimationTree"
onready var player_node = $"/root/Spatial/Player" as KinematicBody

var forward_backward_interp = 0

var desired_dir_interp = Vector3.ZERO

func _ready():
	$"Gardevoir/Skeleton/Head".set_layer_mask_bit(0, false)

func _process(delta):
	var direction_moved = player_node.get("current_move_direction")
	var desired_direction = player_node.get("current_desired_direction") as Vector3
	var max_speed = player_node.get("speed")
	var movement_speed = player_node.get("current_speed")
	
	desired_dir_interp = desired_dir_interp.linear_interpolate(desired_direction, delta)
	var ddinterp_zx = Vector2(desired_dir_interp.z, desired_dir_interp.x)
	
	var walk_speed = movement_speed / 28.0
	animation_tree.set("parameters/1/TimeScale/scale", walk_speed)
	animation_tree.set("parameters/2/TimeScale/scale", walk_speed)
	animation_tree.set("parameters/3/TimeScale/scale", walk_speed)
	animation_tree.set("parameters/4/TimeScale/scale", walk_speed)
	
	animation_tree.set("parameters/blend_position", ddinterp_zx)
	
	
func __animate_states():
	var direction_moved = player_node.get("current_move_direction")
	var desired_direction = player_node.get("current_desired_direction")
	var max_speed = player_node.get("speed")
	var movement_speed = player_node.get("current_speed")
	
	var acceleration_sortof = clamp((direction_moved * movement_speed).dot(player_node.transform.basis.x) / max_speed ,-1, 1)
	if desired_direction == Vector3.ZERO:
		forward_backward_interp = forward_backward_interp / 1.1
	else:
		forward_backward_interp += acceleration_sortof / 8.0
	forward_backward_interp = clamp(forward_backward_interp, -1, 1)
	forward_backward_interp = 0 if abs(forward_backward_interp) < 0.01 else forward_backward_interp
	
	
	var walk_speed = movement_speed / 22.0
	animation_tree.set("parameters/walk_speed/scale", walk_speed)
	animation_tree.set("parameters/walk_speed_2/scale", walk_speed)
	
	var blend = forward_backward_interp
	prints(desired_direction)
	animation_tree.set("parameters/walk_dir_blend/blend_amount", blend)
	#animation_tree.set("parameters/forwards_backwards_blend/blend_amount", forward_backward_interp)
