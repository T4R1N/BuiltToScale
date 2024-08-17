extends Node

@export var stage: PackedScene

func _ready():
	$Jukebox.play()

func _on_menu_begin():
	$TransitionScreen.transition()
	$AudioAnimator.play("menu_fade_out")
	

func _on_transition_screen_transitioned():
	var to_stage = stage.instantiate()
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(to_stage)
