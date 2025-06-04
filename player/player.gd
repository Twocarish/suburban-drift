extends CharacterBody3D

@onready var player_camera = $Camera3D

# this method is called on startup and locks the player's mouse to the screen.
func _ready():
	Input.set_mouse_mode(Input.MouseMode.MOUSE_MODE_CAPTURED)

# called every physics tick
func _physics_process(delta):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# BUG : player slows down when they look down. i kind of like it honestly
	# player's input multiplied by their facing direction
	var forward = Vector3(player_camera.global_transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	var target_velocity = forward * 5.0
	if is_on_floor(): 
		velocity = velocity.lerp(velocity + target_velocity, delta)
		# simulates friction
		velocity = velocity.lerp(Vector3.ZERO, delta * 2.5)
	else:
		# NOTE : you can bhop right now, might be too silly too keep though
		# limited air control and gravity
		velocity = velocity.lerp(velocity + (target_velocity * 0.4), delta)
		velocity.y -= (5 * delta)
	move_and_slide()

# player's inputs are processed through this method first
func _input(event):
	# camera rotation
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x / 1000)
		player_camera.rotate_x(-event.relative.y / 1000)
		player_camera.rotation.x = clampf(player_camera.rotation.x, -deg_to_rad(89), deg_to_rad(89))
	# jumping. 'nuff said
	elif event.is_action_pressed("jump") and is_on_floor():
		velocity.y += 2
