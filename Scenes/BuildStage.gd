extends Node2D

@onready var inv_database = get_node("/root/Main/InventoryDatabase")
@onready var regular_inventory = $CanvasLayer/Control/RegularInventory
@onready var infinite_inventory = $CanvasLayer/Control/InfiniteInventory
@onready var skeleton_inventory = $CanvasLayer/Control/SkeletonInventory

@onready var inv_slot: PackedScene = preload("res://Inventory/InvSlot.tscn")
@onready var skeleton_slots: Array[InvSlot] = [$CanvasLayer/Control/SkeletonInventory/LeftArm, $CanvasLayer/Control/SkeletonInventory/RightArm, $CanvasLayer/Control/SkeletonInventory/LeftLeg, $CanvasLayer/Control/SkeletonInventory/RightLeg]

var cur_skelly: RobotSkeleton = preload("res://Robot/Skeletons/MakeshiftBipedal.tres")

func passes_checks(): # If the player tries to play without filling out the character's limbs, it won't work
	for arm in cur_skelly.arms:
		if arm == null:
			return false
	for leg in cur_skelly.legs:
		if leg == null:
			return false
	return true

func move_inv_piece():
	pass
	
func move_infinite_piece():
	pass

func set_skeleton(piece: RobotSkeleton):
	cur_skelly = piece
	

func append_piece(piece: AbstractRobotPiece, right: bool) -> void:
	match piece:
		RobotSkeleton:
			set_skeleton(piece)
		RobotArm:
			if right:
				cur_skelly.arms[1] = piece
				$RightArm.texture = piece.texture
			else:
				cur_skelly.arms[0] = piece
				$LeftArm.texture = piece.texture
		RobotLeg:
			if right:
				cur_skelly.legs[1] = piece
				$RightLeg.texture = piece.texture
			else:
				cur_skelly.legs[0] = piece
				$LeftLeg.texture = piece.texture
		RobotAugment:
			pass

func load_slots(): # I'm very sorry about my awful, unreadable code.
	var cur_slot: InvSlot
	var slots = regular_inventory.get_children()
	for i in range(slots.size()):
		slots[i].which_inv_type = "Regular"
		
		var correspo_piece = inv_database.inventory.inv_data[i]
		if correspo_piece != null:
			slots[i].hold = correspo_piece
			slots[i].set_sprite(correspo_piece.texture)

	slots = infinite_inventory.get_children()
	for i in range(slots.size()):
		slots[i].which_inv_type = "Infinite"
		
		var correspo_piece = inv_database.inf_inventory[i]
		if correspo_piece != null:
			slots[i].hold = correspo_piece
			slots[i].set_sprite(correspo_piece.texture)
	
	
	# I made it a for loop thank god
	
	cur_slot = skeleton_inventory.get_child(0)
	cur_slot.set_sprite(cur_skelly.texture)
	cur_slot.set_inv_type("Skeleton")
	
	for i in range(skeleton_slots.size()):
		cur_slot = skeleton_slots[i]
		cur_slot.set_inv_type("Skeleton")
		if i < 2: # If it's an arm
			if cur_skelly.arms[i] != null:
				cur_slot.hold = cur_skelly.arms[i]
				cur_slot.set_sprite(cur_skelly.arms[i].texture)
		else: # It's a leg
			if cur_skelly.legs[i - 2] != null:
				cur_slot.hold = cur_skelly.legs[i - 2]
				cur_slot.set_sprite(cur_skelly.legs[i - 2].texture)
	
	
	#cur_slot = skeleton_inventory.get_child(2)
	#cur_slot.set_inv_type("Skeleton")
	#if cur_skelly.arms[0] != null:
		#cur_slot.set_sprite(cur_skelly.arms[0].texture)
		#
	#cur_slot = skeleton_inventory.get_child(3)
	#cur_slot.set_inv_type("Skeleton")
	#if cur_skelly.arms[1] != null:
		#cur_slot.set_sprite(cur_skelly.arms[1].texture)
	#
	#cur_slot = skeleton_inventory.get_child(5)
	#cur_slot.set_inv_type("Skeleton")
	#if cur_skelly.legs[0] != null:
		#cur_slot.set_sprite(cur_skelly.legs[0].texture)
	#
	#cur_slot = skeleton_inventory.get_child(6)
	#cur_slot.set_inv_type("Skeleton")
	#if cur_skelly.legs[1] != null:
		#cur_slot.set_sprite(cur_skelly.legs[1].texture)
	#
	if cur_skelly.augments.size() > 0:
		for i in range(cur_skelly.augments.size()):
			cur_slot = skeleton_inventory.get_child(8 + i)
			cur_slot.set_inv_type("Skeleton")
			cur_slot.set_sprite(cur_skelly.augments[i].texture)
			
			
			

func load_sprites():
	$Skeleton.texture = cur_skelly.texture
	
	if cur_skelly.arms[0] == null:
		$LeftArm.texture = null
	else:
		$LeftArm.texture = cur_skelly.arms[0].texture
		
	if cur_skelly.arms[1] == null:
		$RightArm.texture = null
	else:
		$RightArm.texture = cur_skelly.arms[1].texture
		
	if cur_skelly.legs[0] == null:
		$LeftLeg.texture = null
	else:
		$LeftLeg.texture = cur_skelly.legs[0].texture
		
	if cur_skelly.legs[1] == null:
		$RightLeg.texture = null
	else:
		$RightLeg.texture = cur_skelly.legs[1].texture
		

func set_skel_val(holding: AbstractRobotPiece, right: bool, which_inv_type: String, which_slot: InvSlot): # Called upon pressing a slot
	if holding == null:
		match which_slot.name:
			#"Skeleton":
				#cur_skelly
			"LeftArm":
				cur_skelly.arms[0] = null
			"RightArm":
				cur_skelly.arms[1] = null
			"LeftLeg":
				cur_skelly.legs[0] = null
			"RightLeg":
				cur_skelly.legs[1] = null
	
	if holding is RobotArm:
		if right:
			cur_skelly.arms[1] = holding
		else:
			cur_skelly.arms[0] = holding
	elif holding is RobotLeg:
		if right:
			cur_skelly.legs[1] = holding
		else:
			cur_skelly.legs[0] = holding
	elif holding is RobotAugment:
		pass
	elif holding is RobotSkeleton:
		inv_database.pickup(cur_skelly)
		cur_skelly = holding

func reload_slots(): #not loading.
	var cur_slot: InvSlot
	var slots = regular_inventory.get_children()
	
	
	for i in range(slots.size()):
		if inv_database.inventory.inv_data[i] != null and slots[i].hold == null:
			print(inv_database.inventory.inv_data[i])
			slots[i].hold = inv_database.inventory.inv_data[i]
		
		cur_slot = slots[i]
		if cur_slot.hold != null:
			cur_slot.set_sprite(cur_slot.hold.texture)
		else:
			cur_slot.set_sprite(null)

	slots = infinite_inventory.get_children()
	for i in range(slots.size()):
		if slots[i].hold != null:
			slots[i].set_sprite(slots[i].hold.texture)
			
			
	cur_slot = skeleton_inventory.get_child(0)
	cur_slot.set_sprite(cur_skelly.texture)
	
	for i in range(skeleton_slots.size()):
		cur_slot = skeleton_slots[i]
		if i < 2: # If it's an arm
			if cur_skelly.arms[i] != null:
				cur_slot.set_sprite(cur_skelly.arms[i].texture)
			else:
				cur_slot.set_sprite(null)
		else: # It's a leg
			if cur_skelly.legs[i - 2] != null:
				cur_slot.set_sprite(cur_skelly.legs[i - 2].texture)
			else:
				print(cur_skelly.legs[i - 2])
				cur_slot.set_sprite(null)
	#slots = infinite_inventory.get_children()
	#for i in range(slots.size()):
	#	if slots[i] is InvSlot && slots[i].holding != null:
	#		slots[i].set_sprite(slots[i].holding.texture)

func reload():
	reload_slots()
	load_sprites()
	
	
func create_slots():
	for i in range(inv_database.inventory.inv_data.size()):
		var sl = inv_slot.instantiate()
		regular_inventory.add_child(sl)
		sl.place_id = i

func _ready():
	
	create_slots()
	load_slots()
	load_sprites()
	#for button in $ButtonList.get_children():
	#	button.pressed.connect(on_pressed.bind(button))


func _on_button_pressed():
	if passes_checks():
		inv_database.hold_skeleton(cur_skelly)
		$/root/Main.go_to_scene("Stage")
