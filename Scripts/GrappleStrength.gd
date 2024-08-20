extends HBoxContainer

@onready var player = $"../../../Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$GrappleStrengthL.value = player.cur_grap / player.grapple_strength
	$GrappleStrengthR.value = player.cur_grap / player.grapple_strength
