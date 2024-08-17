extends CanvasLayer

signal transitioned

func _ready():
	$AnimationPlayer.play("fade_to_normal")

func transition():
	$AnimationPlayer.play("fade_to_black")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		transitioned.emit()
		$AnimationPlayer.play("fade_to_normal")
