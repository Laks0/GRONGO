extends KinematicBody2D

var speed
var angle

func throw(sp,to):
	speed = sp
	angle = (to - position).normalized()

func _physics_process(delta):
#	move_and_slide(angle*speed)
	position += angle*speed*delta
	if position.x < 0 or position.y < 0 or position.x > 1280 or position.y > 720:
		get_parent().remove_child(self)
