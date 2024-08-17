extends StaticBody2D

var damage = 1.0

func _ready():
	$AnimationPlayer.play("rotate")
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "rotate":
		$AnimationPlayer.play("rotate")

func _physics_process(delta):
	for body in $Area2D.get_overlapping_bodies():
		if body is Player:
			body.take_damage(damage)
