extends CharacterBody2D

class_name Player

@export var skeleton: RobotSkeleton

var num_jumps = 1
var jumps = num_jumps
var JUMP_VELOCITY = -600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 1600

var acceleration = 3000.0
var maxSpeed = 800.0
var grapple_strength = 400.0
var cur_grap: float

var can_move_in_air = true # For use with augments
var can_walk_to_climb = false # Spiderbody
var cancel_jump = false

@onready var mass = skeleton.mass
@onready var max_hp = skeleton.durability
var hp: float
@onready var ingame_ui = $"../IngameUI"

func build():
	for i in skeleton.arms:
		mass += i.mass
		max_hp += i.durability
		grapple_strength += i.grapple_strength

	for i in skeleton.legs:
		mass += i.mass
		max_hp += i.durability
		
		acceleration += i.accel_boost
		maxSpeed += i.speed_boost
		JUMP_VELOCITY -= i.jump_boost

	for i in skeleton.augments:
		if not i == null:
			ingame_ui.make_aug(i)
			
			mass += i.mass
			max_hp += i.durability
			num_jumps += i.extra_jumps
			if i.do_jump_cancel:
				cancel_jump = true
	
	hp = max_hp
	
	ingame_ui.set_gui_label("Durability", max_hp)
	ingame_ui.set_gui_label("Mass", mass)
	ingame_ui.set_gui_label("Speed", maxSpeed)
	ingame_ui.set_gui_label("Jump", abs(JUMP_VELOCITY)) # non-negative
	ingame_ui.set_gui_label("Traction", acceleration)
	ingame_ui.set_gui_label("Grapple", grapple_strength)
	
	$SkeletonSprite.texture = skeleton.texture
	match skeleton.designation:
		"Bipedal":
			pass
		"Bipedal+":
			pass

func _ready():
	build()

func take_damage(dmg: float):
	hp -= dmg

func _process(delta):
	ingame_ui.set_health_bar((hp / max_hp) * 100.0)

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
		
	if cancel_jump and velocity.y < 0 and Input.is_action_just_released("Jump"): # Does not execute if falling; only activates if cancelling a jump
		velocity.y = 0
	
	# Acceleration and deceleration
	if is_on_floor():
		velocity.x = move_toward(velocity.x, maxSpeed * direction, acceleration * delta)
	elif can_move_in_air && direction: # the && direction exists so you don't decelerate when not holding keys
		velocity.x = move_toward(velocity.x, maxSpeed * direction, acceleration / 2 * delta)

	if velocity.x > 0:
		$SkeletonSprite.flip_h = false
	elif velocity.x < 0:
		$SkeletonSprite.flip_h = true

	move_and_slide()
