extends Node2D

@onready var inv_database = get_node("/root/Main/InventoryDatabase")
@onready var regular_inventory = $CanvasLayer/Control/RegularInventory
@onready var infinite_inventory = $CanvasLayer/Control/InfiniteInventory

var cur_skelly: RobotSkeleton = preload("res://Robot/Skeletons/MakeshiftBipedal.tres")

func passes_checks(): # If the player tries to play without filling out the character's limbs, it won't work
	for i in cur_skelly.arms:
		if i == null:
			return false
	for i in cur_skelly.legs:
		if i == null:
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

func load_slots():
	var slots = regular_inventory.get_children()
	for i in range(slots.size()):
		var correspo_piece = inv_database.inventory[i]
		if correspo_piece != null:
			slots[i].set_sprite(correspo_piece.texture)

	slots = infinite_inventory.get_children()
	for i in range(slots.size()):
		var correspo_piece = inv_database.inf_inventory[i]
		if correspo_piece != null:
			slots[i].set_sprite(correspo_piece.texture)

func load_sprites():
	$Skeleton.texture = cur_skelly.texture
	
	for i in cur_skelly.arms:
		if i == null:
			return false
	for i in cur_skelly.legs:
		if i == null:
			return false
	return true

func _ready():
	load_slots()
