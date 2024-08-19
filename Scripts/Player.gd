extends CharacterBody2D

class_name Player

@export var skeleton: RobotSkeleton

var num_jumps = 1
var additional_jumps = num_jumps
var time_since_jump = INF
var time_since_grounded = INF
var JUMP_VELOCITY = -600.0

var gravity = 1600
var prevVelocity = Vector2.ZERO
var in_freefall = false
var scream_played = false

var acceleration = 3000.0
var maxSpeed = 800.0
var grapple_strength = 400.0
var cur_grap: float
var hp: float

var canClimb = false
var isClimbing = false

var can_move_in_air = true # For use with augments
var can_walk_to_climb = false # Spiderbody
var cancel_jump = false

var DEAD = false

@onready var mass = skeleton.mass
@onready var max_hp = skeleton.durability
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

func flip_all_sprites():
	if velocity.x > 0:
		$SkeletonSprite.scale.x = 0.2
		#$SkeletonSprite/Arm1.flip_h = false
		#$SkeletonSprite/Arm1.z_index = 0
		#$SkeletonSprite/Arm2.flip_h = false
		#$SkeletonSprite/Arm2.z_index = -1
		#$SkeletonSprite/Arm3.flip_h = false
		#$SkeletonSprite/Arm3.z_index = 0
		#$SkeletonSprite/Arm4.flip_h = false
		#$SkeletonSprite/Arm4.z_index = -1
	elif velocity.x < 0:
		$SkeletonSprite.scale.x = -0.2
		#$SkeletonSprite/Arm1.flip_h = true
		#$SkeletonSprite/Arm1.z_index = -1
		#$SkeletonSprite/Arm2.flip_h = true
		#$SkeletonSprite/Arm2.z_index = 0
		#$SkeletonSprite/Arm3.flip_h = true
		#$SkeletonSprite/Arm3.z_index = -1
		#$SkeletonSprite/Arm4.flip_h = true
		#$SkeletonSprite/Arm4.z_index = 0

func _ready():
	build()

func take_damage(dmg: float):
	hp -= dmg

func _process(delta):
	ingame_ui.set_health_bar((hp / max_hp) * 100.0)

func _physics_process(delta):
	# Check for freefall
	if velocity.y > 3000:
		in_freefall = true
		if velocity.x > 0:
			$SkeletonSprite.rotation += delta * 20
		else:
			$SkeletonSprite.rotation -= delta * 20
		#var angleVector = Vector2(cos($SkeletonSprite.rotation), sin($SkeletonSprite.rotation))
		#$SkeletonSprite.rotation += angleVector.angle_to(velocity)
		velocity.y += gravity * delta
		time_since_grounded += delta
	else:
		in_freefall = false
		$SkeletonSprite.rotation = 0
	
	if in_freefall:
		if !scream_played:
			$scream.pitch_scale = randf_range(0.9, 1.1)
			$scream.play()
			scream_played = true
	else:
		scream_played = false
		
		# Climbing
		if canClimb and Input.is_action_pressed("Grab"):
			#if !isClimbing:
				#velocity = Vector2.ZERO
			isClimbing = true
		else:
			isClimbing = false
		
		if isClimbing:
			gravity = 0
			
			var climbDir = Vector2(Input.get_axis("Left", "Right"), Input.get_axis("Jump", "Down")).normalized()
			velocity = velocity.move_toward(maxSpeed / 2.0 * climbDir, acceleration * delta)
		else:
			gravity = 1600
			
			# BEGIN REGULAR PLATFORM CODE
			var direction = Input.get_axis("Left", "Right")
			
			# Gravity
			if !is_on_floor():
				#if Input.is_action_pressed("Jump") and velocity.y < 0:
					#gravity = 1200
				#else:
					#gravity = 1600
				velocity.y += gravity * delta
				time_since_grounded += delta
			else:
				additional_jumps = num_jumps # resets to max jump value
				time_since_grounded = 0
			
			
			# Handle jump input allowing for jump buffering.
			if Input.is_action_just_pressed("Jump"):
				time_since_jump = 0
			else:
				time_since_jump += delta
			
			if time_since_jump < 0.25 and time_since_grounded < 0.15:
				velocity.y = JUMP_VELOCITY
			elif time_since_jump == 0 and additional_jumps > 0:
				additional_jumps -= 1
				velocity.y = JUMP_VELOCITY
				
				# Jump cancel
			if cancel_jump and velocity.y < 0 and !Input.is_action_pressed("Jump"): # Does not execute if falling; only activates if cancelling a jump
				velocity.y = 0
			
			# Acceleration and deceleration
			if is_on_floor():
				velocity.x = move_toward(velocity.x, maxSpeed * direction, acceleration * delta)
			elif can_move_in_air && direction: # the && direction exists so you don't decelerate when not holding keys
				velocity.x = move_toward(velocity.x, maxSpeed * direction, acceleration / 2 * delta)
		
	# Fall Damage
	if prevVelocity.y > JUMP_VELOCITY * -2.5 and is_on_floor():
		take_damage(pow(prevVelocity.y / (JUMP_VELOCITY * -1), 2))
	
	flip_all_sprites()
	prevVelocity = velocity
	move_and_slide()
	
	if hp <= 0:
		DEAD = true
	
	if DEAD:
		get_tree().reload_current_scene()

func set_canClimb(val: bool):
	canClimb = val
