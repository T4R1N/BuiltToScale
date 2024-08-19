extends CharacterBody2D

@export var item: AbstractRobotPiece # Will be set when randomly generated

var gravity = 1600

func _ready():
	$Sprite2D.texture = item.texture

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
