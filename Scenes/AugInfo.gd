extends Control

func set_type(type: String):
	$Label.text = type
	
func set_bar_value(data: float):
	$AugmentBar.value = data
