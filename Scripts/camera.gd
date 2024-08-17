extends Camera2D

@onready var target = get_node("../Player")
var camSpeed = 3.0
var velocity = Vector2.ZERO
const camOffset = Vector2(0, -100) # offset from the target position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var dirTowards = global_position.direction_to(target.get_global_position() + camOffset)
	var distTo = global_position.distance_to(target.get_global_position() + camOffset)
	
	velocity *= 0.8
	velocity += dirTowards * camSpeed * distTo * delta
	
	# basically move_and_slide() but not
	global_position += velocity
