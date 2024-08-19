extends Node

@export var inv: Array[AbstractRobotPiece]

func pickup(piece: AbstractRobotPiece):
	for slot in inv:
		if slot == null:
			slot = piece
			print(slot)
			break
