extends Node

@export var inf_inventory: Array[AbstractRobotPiece]
@export var inventory: Array[AbstractRobotPiece]

var cur_skelly: RobotSkeleton

func pickup(piece: AbstractRobotPiece):
	for slot in inventory:
		if slot == null:
			slot = piece
			print(slot)
			break


func hold_skeleton(skelly: RobotSkeleton):
	cur_skelly = skelly
