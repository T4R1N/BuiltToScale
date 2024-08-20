extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$FlagSprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if monitoring:
		for body in get_overlapping_bodies():
			if body is Player:
				$win.play()
				$"../IngameUI/WinLabel".visible = true
				monitoring = false
				$wait.start()


func _on_wait_timeout():
	$"/root/Main".win()
