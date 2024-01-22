extends CharacterBody3D


@export var player_visual: Node3D

const MAX_SPEED = 7
const ACCELERATION = 30
const FRICTION = 30
const ROTATION_ACCELERATION = 10

var _is_walking: bool = true


func  _physics_process(delta):
	_player_movement(delta)
	

func  _player_movement(delta):
	var input_direction = Input.get_vector("left", "right", "up", "down").normalized()
	var output_velocity: Vector2 = Vector2(velocity.x, velocity.z)
	
	if input_direction == Vector2.ZERO:
		# Slows
		if output_velocity.length() > (FRICTION * delta):
			output_velocity -= output_velocity.normalized() * (FRICTION * delta)
		else:
			output_velocity = Vector2.ZERO
	else:
		# Speeds
		output_velocity += (input_direction * ACCELERATION * delta)
		output_velocity = output_velocity.limit_length(MAX_SPEED)
		
	velocity = Vector3(output_velocity.x, 0, output_velocity.y)
	move_and_slide()
	
	# Rotate
	if input_direction != Vector2.ZERO:
		player_visual.rotation.y = lerp_angle(player_visual.rotation.y, atan2(input_direction.x * 100, input_direction.y * 100), delta * ROTATION_ACCELERATION)
	# Funny:
	#player_visual.look_at(Vector3(input_direction.x, input_direction.x, input_direction.y))
	
	_is_walking = output_velocity != Vector2.ZERO

func is_walking() -> bool:
	return _is_walking