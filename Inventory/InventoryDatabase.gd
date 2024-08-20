extends Node

@export var inf_inventory: Array[AbstractRobotPiece]
@export var inventory: InvData

var cur_skelly: RobotSkeleton

@export var skeletons: Array[RobotSkeleton]

func pickup(piece: AbstractRobotPiece):
	if not piece == null:
		if piece.type == "Default" && piece is RobotSkeleton:
			pass
		else:
			for i in range(inventory.inv_data.size()):
				if inventory.inv_data[i] == null:
					inventory.inv_data[i] = piece
					print(inventory.inv_data[i])
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
