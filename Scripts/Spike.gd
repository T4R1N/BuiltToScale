extends StaticBody2D

var damage = 5.0
@export var gears: bool
var hurt = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if gears:
		$sprite.set_animation("gears")
	else:
		$sprite.set_animation("without")
	$sprite.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for body in $SpikeZone.get_overlapping_bodies():
		if body is Player and !hurt:
			body.take_damage(damage)
			hurt = true


func _on_spike_timer_timeout():
	hurt = false
