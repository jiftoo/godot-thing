extends Spatial

onready var animation_player = $"AnimationPlayer"
onready var player_node = $"/root/Spatial/Player"

func _ready():
	$"Gardevoir/Skeleton/Head".set_layer_mask_bit(0, false)

func _process(delta):
	var movement_speed = player_node.get("current_speed")
	
	if movement_speed > 0:
		animation_player.playback_speed = movement_speed / 20.0 # floor sync
		animation_player.play("Gardevoir|mixamocom|Layer0")
	else:
		animation_player.stop()
