extends Area2D

var canClimb = false
@onready var player = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body is Player:
			player.canClimb = true
	
	#player.canClimb = canClimb



func _on_body_exited(body):
	if body is Player:
		player.canClimb = false
