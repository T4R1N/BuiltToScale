extends CharacterBody2D

@onready var inventory = get_node("/root/Main/InventoryDatabase")
@export var item: AbstractRobotPiece # Will be set when randomly generated

var gravity = 1600

func pickup():
	inventory.pickup(item)
	queue_free()

func set_sprite():
	$Sprite2D.texture = item.texture

func _ready():
	set_sprite()

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
		
	for body in $PickupZone.get_overlapping_bodies():
		if body is Player:
			pickup()
			
	move_and_slide()
