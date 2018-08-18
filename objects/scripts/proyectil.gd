extends KinematicBody2D

var speed
var angle

func throw(sp,to):
	speed = sp
	angle = (to - position).normalized()

func _physics_process(delta):
	move_and_slide(Vector2(100,100))
	if position.x < 0 or position.y < 0 or position.x > 1280 or position.y > 20:
		get_parent().remove_child(self)
