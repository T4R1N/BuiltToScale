extends Camera2D

@onready var target = get_node("../Player")
var camSpeed = 3.0
var velocity = Vector2.ZERO
const camOffset = Vector2(0, -100) # offset from the target position

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = target.get_global_position()
	var width_ratio = DisplayServer.window_get_size().x / 2560.0
	zoom = Vector2(width_ratio, width_ratio)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var dirTowards = global_position.direction_to(target.get_global_position() + camOffset)
	var distTo = global_position.distance_to(target.get_global_position() + camOffset)
	
	velocity *= 0.8 #damp isnt based on delta because its annoying to do that
	velocity += dirTowards * camSpeed * distTo * delta
	if target.is_on_floor():
		# basically move_and_slide() but not
		global_position += velocity
	else:
		global_position = lerp(global_position, target.get_global_position() + camOffset, .2)
