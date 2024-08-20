extends Node

@export var stage: PackedScene
@export var build_stage: PackedScene
@export var menu: PackedScene

var cur_scene: PackedScene

func _ready():
	$Jukebox.play()

func go_to_scene(name_of_scene: String):
	match name_of_scene:
		"Stage":
			cur_scene = stage
		"Build Stage":
			cur_scene = build_stage
		"Home":
			cur_scene = menu
	
	$TransitionScreen.transition()

func death():
	$InventoryDatabase.death_cleanup()
	go_to_scene("Build Stage")

func _on_menu_begin():
	go_to_scene("Build Stage")
	$AudioAnimator.play("menu_fade_out")
	$Wind.play()
	

func _on_transition_screen_transitioned():
	var to_stage = cur_scene.instantiate()
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(to_stage)

func win():
	go_to_scene("Home")
	$AudioAnimator.play("RESET")
	$Wind.stop()
	$Jukebox.play()
