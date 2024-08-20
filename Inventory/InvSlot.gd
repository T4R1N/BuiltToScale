extends Panel
class_name InvSlot

@export var hold: AbstractRobotPiece
var which_inv_type: String = "Regular"
var place_id: int

@onready var build_stage = get_node("/root/Main/CurrentScene/BuildStage")
@onready var inv_database = $/root/Main/InventoryDatabase

signal action(move: bool)

func set_sprite(texture: Texture):
	if texture != null:
		$TextureRect.texture = texture
	else:
		$TextureRect.texture = null

func set_inv_type(inv_type: String = "Regular"):
	which_inv_type = inv_type

func get_piece() -> AbstractRobotPiece:
	return hold

func set_piece(piece: AbstractRobotPiece) -> void:
	if piece == null:
		hold = null
	else:
		hold = piece


func move_piece(right: bool):
	match which_inv_type:
		"Regular":
			build_stage.set_skel_val(hold, right, which_inv_type, self)
			
			set_piece(null)
			inv_database.remove_piece(hold, place_id)
		"Infinite":
			build_stage.set_skel_val(hold, right, which_inv_type, self)
		"Skeleton":
			if not hold is RobotSkeleton:
				print(hold)
				inv_database.pickup(hold)
				set_piece(null)
				build_stage.set_skel_val(hold, right, which_inv_type, self)
				
	build_stage.reload()

func _on_button_left_click():
	move_piece(false)
	action.emit(false)


func _on_button_right_click():
	move_piece(true)
	action.emit(true)
