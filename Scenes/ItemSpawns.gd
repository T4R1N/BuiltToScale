extends Node2D

@export var item: PackedScene

@export var pieces: Array[AbstractRobotPiece]

@onready var item_points = get_children()

@onready var num_spawns = randi_range(16,24)

func _ready():
	randomize()
	item_points.shuffle()
	

	for item_point in item_points:
		if num_spawns > 0:
			num_spawns -= 1
			var it = item.instantiate()
			print(it)
			add_child(it)
			it.set_global_position(item_point.get_global_position())
			it.item = pieces[randi_range(0,pieces.size()-1)]
			it.set_sprite()
		else:
			break

