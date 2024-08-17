extends CanvasLayer

@onready var dura_label = $Control/DataContainer/DuraLabel
@onready var mass_label = $Control/DataContainer/MassLabel

func set_gui_label(which: String, data: float):
	match which:
		"Durability":
			$Control/DataContainer/DuraLabel.text = "Durability: " + str(data)
		"Mass":
			$Control/DataContainer/MassLabel.text = "Mass: " + str(data)
		"Speed":
			$Control/DataContainer/MinorStatContainer/Speed.text = "speed: " + str(data)
		"Jump":
			$Control/DataContainer/MinorStatContainer/Jump.text = "jump_strength: " + str(data)
		"Traction":
			$Control/DataContainer/MinorStatContainer/Traction.text = "traction: " + str(data)
		"Grapple":
			$Control/DataContainer/MinorStatContainer/Grapple.text = "grapple_strength: " + str(data)

func make_aug(aug: RobotAugment):
	$Control/OtherContainer/AugContainer.create_aug_info_ui(aug)
	
func set_grapple_bar():
	pass
	
func set_health_bar(data: float):
	$Control/OtherContainer/HPBar.value = data