extends CharacterBody2D

class_name Player

@export var skeleton: RobotSkeleton

var num_jumps = 0
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

var mass: float
var max_hp: float

#QUICK!!!
var walkmod: float
var prevWalk: float

@onready var ingame_ui = $"../IngameUI"
@onready var inv_database = get_node("/root/Main/InventoryDatabase")

func build():
	skeleton = inv_database.cur_skelly
	
	mass = skeleton.mass
	max_hp = skeleton.durability
	num_jumps += skeleton.extra_jumps
	additional_jumps = num_jumps
	
	print(str(skeleton.type) + str(skeleton.arms) + str(skeleton.legs))
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
	cur_grap = grapple_strength
	
	ingame_ui.set_gui_label("Durability", max_hp)
	ingame_ui.set_gui_label("Mass", mass)
	ingame_ui.set_gui_label("Speed", maxSpeed)
	ingame_ui.set_gui_label("Jump", abs(JUMP_VELOCITY)) # non-negative
	ingame_ui.set_gui_label("Traction", acceleration)
	ingame_ui.set_gui_label("Grapple", grapple_strength)
	
	$SkeletonSprite.texture = skeleton.texture
	$SkeletonSprite/Arm1.texture = skeleton.arms[0].texture
	$SkeletonSprite/Arm2.texture = skeleton.arms[1].texture
	$SkeletonSprite/Arm3.texture = skeleton.legs[0].texture
	$SkeletonSprite/Arm4.texture = skeleton.legs[1].texture

func flip_all_sprites():
	if velocity.x > 0:
		$SkeletonSprite.scale.x = 4
	elif velocity.x < 0:
		$SkeletonSprite.scale.x = -4

func _ready():
	build()
	$Animations.play("idle")
	$Animations.speed_scale = 0.5

func take_damage(dmg: float):
	$hurt.play()
	hp -= dmg

func _process(delta):
	ingame_ui.set_health_bar((hp / max_hp) * 100.0)

func _physics_process(delta):
	# Check for freefall
	if velocity.y > 3000:
		in_freefall = true
		if velocity.x > 0:
			$SkeletonSprite.rotation += (velocity.y - 3000) / 100 * delta
		else:
			$SkeletonSprite.rotation -= (velocity.y - 3000) / 100 * delta
		#var angleVector = Vector2(cos($SkeletonSprite.rotation), sin($SkeletonSprite.rotation))
		#$SkeletonSprite.rotation += angleVector.angle_to(velocity)
		velocity.y += gravity * delta
		time_since_grounded += delta
	else:
		in_freefall = false
		$SkeletonSprite.rotation = 0
	
	if in_freefall:
		if !scream_played:
			$scream.pitch_scale = randf_range(0.84, 1.16)
			$scream.play()
			scream_played = true
	else:
		scream_played = false
		
		# Climbing
		
		if canClimb and Input.is_action_pressed("Grab") and cur_grap > 0:
			isClimbing = true
		else:
			isClimbing = false
		
		if isClimbing:
			gravity = 0
			var climbDir = Vector2(Input.get_axis("Left", "Right"), Input.get_axis("Jump", "Down")).normalized()
			cur_grap -= delta * 50
			if climbDir:
				cur_grap -= delta * 100
				cur_grap = clamp(cur_grap, 0, grapple_strength)
			velocity = velocity.move_toward((maxSpeed * 0.3 * climbDir) + grapple_strength * 0.3 * climbDir, acceleration * delta)
		elif !DEAD:
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
				cur_grap += delta * 200
				cur_grap = clamp(cur_grap, 0, grapple_strength)
				additional_jumps = num_jumps # resets to max jump value
				time_since_grounded = 0
			
			
			# Handle jump input allowing for jump buffering.
			if Input.is_action_just_pressed("Jump"):
				time_since_jump = 0
			else:
				time_since_jump += delta
			
			if time_since_jump < 0.25 and time_since_grounded < 0.15:
				velocity.y = JUMP_VELOCITY
				$jump.pitch_scale = 1
				$jump.play()
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
		else: #Dead
			if !is_on_floor():
				#if Input.is_action_pressed("Jump") and velocity.y < 0:
					#gravity = 1200
				#else:
					#gravity = 1600
				velocity.y += gravity * delta
				time_since_grounded += delta
			else:
				cur_grap += delta * 200
				cur_grap = clamp(cur_grap, 0, grapple_strength)
				additional_jumps = num_jumps # resets to max jump value
				time_since_grounded = 0
	# Fall Damage
	if prevVelocity.y > JUMP_VELOCITY * -2.5 and is_on_floor():
		take_damage(pow(prevVelocity.y / (JUMP_VELOCITY * -1), 2))
	
	# Animations and visuals
	flip_all_sprites()
	if is_on_floor():
		if abs(velocity.x) > 1:
			$Animations.play("run_animation")
			$Animations.speed_scale = abs(velocity.x) / 500
			prevWalk = walkmod
			walkmod = fmod($Animations.current_animation_position, 0.5)
			if prevWalk > walkmod:
				$walk.pitch_scale = randf_range(0.2, 0.25)
				$walk.play()
		else:
			$Animations.play("idle")
			$Animations.speed_scale = 0.5
	else:
		$Animations.play("fall")
		$Animations.speed_scale = abs(velocity.y / 1000)
	
	
	prevVelocity = velocity
	move_and_slide()
	
	if hp <= 0 or global_position.y > 10000:
		DEAD = true
		if is_on_floor():
			velocity.x = 0
	
	if DEAD:
		$"/root/Main".death()


func _on_walk_timer_timeout():
	$walk.play()
