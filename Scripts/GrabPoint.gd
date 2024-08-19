extends Area2D

var canClimb = false
signal climb

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	climb.emit(canClimb)


func _on_body_entered(body):
	if body is Player:
		canClimb = true


func _on_body_exited(body):
	if body is Player:
		canClimb = false