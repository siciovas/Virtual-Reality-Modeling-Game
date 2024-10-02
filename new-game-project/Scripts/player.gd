extends CharacterBody3D

@onready var Cam = $Head/Camera3D as Camera3D
@onready var timer_label = $CanvasLayer/Label as Label  # Reference to the TimerLabel
var mouseSensibility = 1200
var mouse_relative_x = 0
var mouse_relative_y = 0
const SPEED = 5.0
const JUMP_VELOCITY = 5.0
var gunfire = 1

@onready var gunshotSound = $gunshotSound
@onready var gun = $CanvasLayer/Control/gun as TextureRect
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var original_position: Vector2
var elapsed_time: float = 0.0  # Timer variable

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	original_position = gun.position

func _physics_process(delta):
	elapsed_time += delta  # Update the timer
	timer_label.text = "Passed time " + str(int(elapsed_time)) + "s"  # Display whole seconds only

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_pressed("Shoot"):
		shoot()

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / mouseSensibility
		$Head/Camera3D.rotation.x -= event.relative.y / mouseSensibility
		$Head/Camera3D.rotation.x = clamp($Head/Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		mouse_relative_x = clamp(event.relative.x, -50, 50)
		mouse_relative_y = clamp(event.relative.y, -50, 10)

func shoot():
	gunshotSound.play()

	if gun:
		gun.position.y -= 10  # Move the gun up for recoil effect
		await get_tree().create_timer(0.1).timeout  # Wait for a short moment
		gun.position = original_position  # Return to the original position

		if gunfire == 1:
			$CanvasLayer/Control/gunfire.emitting = true
			gunfire = 2
		else:
			$CanvasLayer/Control/gunfire2.emitting = true
			gunfire = 1

func kill():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://Scenes/gameover.tscn")
