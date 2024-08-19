extends Node

@export var inf_inventory: Array[AbstractRobotPiece]
@export var inventory: Array[AbstractRobotPiece]



func pickup(piece: AbstractRobotPiece):
	for slot in inventory:
		if slot == null:
			slot = piece
			print(slot)
			break

func load_slots():
	pass

func insert_player():
	pass


	return true
