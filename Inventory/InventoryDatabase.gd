extends Node

@export var inf_inventory: Array[AbstractRobotPiece]
@export var inventory: InvData

var cur_skelly: RobotSkeleton

func pickup(piece: AbstractRobotPiece):
	for slot in inventory.inv_data:
		if slot == null:
			slot = piece
			print(slot)
			break


func hold_skeleton(skelly: RobotSkeleton):
	cur_skelly = skelly

func _ready():
	print(inventory)
	print(inventory.inv_data)
