extends StaticBody2D

var damage = 1.0

func _ready():
	$SawFrames.play("default")

func _physics_process(delta):
	for body in $Area2D.get_overlapping_bodies():
		if body is Player:
			body.take_damage(damage)
