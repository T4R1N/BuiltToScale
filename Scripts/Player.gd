extends CharacterBody2D

@export var skeleton: RobotSkeleton

var num_jumps = 1
var jumps = num_jumps
var JUMP_VELOCITY = -600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 1600

var acceleration = 1000.0
var maxSpeed = 500.0
var canMoveInAir = true # For use with augments

func build():
	for i in skeleton.arms:
		pass
	for i in skeleton.legs:
		acceleration += i.accel_boost
		maxSpeed += i.speed_boost
	for i in skeleton.augments:
		if not i == null:
			num_jumps += i.extra_jumps

func _ready():
	build()

func _physics_process(delta):
	var direction = Input.get_axis("Left", "Right")
	
	# Gravity
	if !is_on_floor():
		if Input.is_action_pressed("Jump") and velocity.y < 0:
			gravity = 1100
		else:
			gravity = 1600
		velocity.y += gravity * delta
	else:
		jumps = num_jumps # resets to max jump value
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and jumps > 0:
		jumps -= 1
		velocity.y = JUMP_VELOCITY
	
	# Acceleration and deceleration
	if is_on_floor():
		velocity.x = move_toward(velocity.x, maxSpeed * direction, acceleration * delta)
	elif canMoveInAir && direction: # the && direction exists so you don't decelerate when not holding keys
		velocity.x = move_toward(velocity.x, maxSpeed * direction, acceleration / 2 * delta)

	move_and_slide()
