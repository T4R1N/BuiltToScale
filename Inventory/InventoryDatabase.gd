extends Node

@export var inf_inventory: Array[AbstractRobotPiece]
@export var inventory: InvData

var cur_skelly: RobotSkeleton

@export var skeletons: Array[RobotSkeleton]

func pickup(piece: AbstractRobotPiece):
	for slot in inventory.inv_data:
		if slot == null:
			slot = piece
			print(slot)
			break

func remove_piece(piece: AbstractRobotPiece, place_id: int):
	inventory.inv_data[place_id] = null
			

func death_cleanup():
	for skeleton in skeletons:
		for i in range(skeleton.arms.size()):
			skeleton.arms[i] = null
		for i in range(skeleton.legs.size()):
			skeleton.legs[i] = null
	cur_skelly = null
	
	

func hold_skeleton(skelly: RobotSkeleton):
	cur_skelly = skelly
	print(cur_skelly)

func _ready():
	print(inventory)
	print(inventory.inv_data)
