extends VBoxContainer

@export var aug_info: PackedScene
# will add stuff for each augment

func create_aug_info_ui(aug: RobotAugment):
	var ai = aug_info.instantiate()
	add_child(ai)
	ai.set_type(aug.type)
