extends CharacterBody3D

const MOVE_SPEED = 5
const JUMP_VELOCITY = 8

@onready var raycast = $RayCast3D
@onready var anim_player = $AnimationPlayer
@onready var timer = $Timer

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var isStuck = false
var player = null
var dead = false

func _ready():
	anim_player.play("walk")
	add_to_group("zombies")
	raycast.enabled = true  # Ensure RayCast is enabled

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if dead or player == null:
		return

	var vec_to_player = player.global_transform.origin - global_transform.origin
	var direction = vec_to_player.normalized()

	if direction.length_squared() > 0.01:  # Check if the direction is not close to zero
		velocity.x = direction.x * MOVE_SPEED
		velocity.z = direction.z * MOVE_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, MOVE_SPEED)
		velocity.z = move_toward(velocity.z, 0, MOVE_SPEED)

	if !isStuck:
		move_and_slide()

	# Check for collision with the player using RayCast3D
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider and collider.name == "Player":
			collider.kill()  # Call the kill function on the player

func kill():
	dead = true
	$CollisionShape3D.disabled = true
	anim_player.play("die")

func set_player(p):
	player = p

func _on_timer_timeout():
	velocity.y = JUMP_VELOCITY
	timer.wait_time = randf_range(5, 15)
	timer.start()
