extends KinematicBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var sensitivity = 0.12
var speed = 15.0 # 15.0 - optimal # maximum speed value
var acceleration = 35.5

onready var camera = $"CameraHinge"

export var current_speed = 0
var current_move_direction = Vector3(0, 0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		process_look(event)
	if event is InputEventKey:
		process_input(event)

func _physics_process(delta):
	process_movement(delta)
	
	
	
func process_look(event: InputEventMouseMotion):
	# Up-down
	camera.rotation_degrees.z -= event.relative.y * sensitivity
	camera.rotation_degrees.z = clamp(camera.rotation_degrees.z, -90, 90)
	#Left-right
	rotation_degrees.y -= event.relative.x * sensitivity

func process_movement(delta: float):
	var direction = Vector3(0, 0, 0)
	direction.x += Input.is_key_pressed(KEY_W) as float
	direction.x -= Input.is_key_pressed(KEY_S) as float
	direction.z += Input.is_key_pressed(KEY_D) as float
	direction.z -= Input.is_key_pressed(KEY_A) as float
	direction = direction.normalized()
	
	if direction != Vector3.ZERO:
		current_speed += acceleration * delta
	else:
		current_speed -= acceleration * delta
	current_speed = clamp(current_speed, 0, speed)
	
	var local_direction = direction.rotated(Vector3(0,1,0), rotation.y)
	
	if current_move_direction.dot(local_direction) <= 0 and direction != Vector3.ZERO:
		current_speed = 0
	
	if direction != Vector3.ZERO:
		current_move_direction = local_direction
		
	var gravity = Vector3.DOWN * 12
		
	move_and_slide_with_snap(current_move_direction * current_speed * (delta * 10), Vector3.DOWN, Vector3.UP, true)
	# doesn't work if added to movement vector of above
	move_and_slide(gravity, Vector3.UP, true)
	

func process_input(event: InputEvent):
	var key = event.scancode
	match key:
		KEY_Q:
			if !event.pressed: toggle_cursor_grab()

func toggle_cursor_grab():
	var mode = Input.mouse_mode
	if mode == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
