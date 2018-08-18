extends KinematicBody2D

export (int) var MAX_SPEED = 500
export (float) var acceleration = 50
export (float) var FRICTION = 20

#Im not sure if this is A LOT OF DAMAGE
var damage = 20
var movement = Vector2()

var direction = 2

onready var walkSound = [
	$Walk1,
	$Walk2
]

func _physics_process(delta):
	### MOVEMENT ###
	
	if Input.is_action_pressed("left") and movement.x > -MAX_SPEED:
		movement.x -= acceleration
		direction = 3
	if Input.is_action_pressed("right") and movement.x < MAX_SPEED:
		movement.x += acceleration
		direction = 1
	if Input.is_action_pressed("up") and movement.y > -MAX_SPEED:
		movement.y -= acceleration
		direction = 4
	if Input.is_action_pressed("down") and movement.y < MAX_SPEED:
		movement.y += acceleration
		direction = 2
	
	movement = slow_down(movement,FRICTION)
	
	movement = move_and_slide(movement)
	
	### ATTACK ###
	
	if Input.is_action_just_pressed("at_all") and $MeleeCool.is_stopped():
		var dir
		if Input.is_action_just_pressed("at_left"):
			dir = $Left
			direction = 3
		if Input.is_action_just_pressed("at_right"):
			dir = $Right
			direction = 1
		if Input.is_action_just_pressed("at_down"):
			dir = $Down
			direction = 2
		if Input.is_action_just_pressed("at_up"):
			dir = $Up
			direction = 4
		
		if dir.is_colliding():
			$Punch.play()
			var col = dir.get_collider()
			if col.is_in_group("Enemy"):
				col.life -= damage
				var knockback
				if col.is_in_group("Boss"):
					knockback = 15
				movement += (position - col.position) * knockback
		
		$MeleeCool.start()
	
	### ANIMATIONS ###
	
	if movement == Vector2(0,0):
		if direction == 1:
			$AnimatedSprite.animation = "IdleRight"
			$AnimatedSprite.flip_h = false
		elif direction == 2:
			$AnimatedSprite.animation = "IdleDown"
			$AnimatedSprite.flip_h = false
		elif direction == 3:
			$AnimatedSprite.animation = "IdleRight"
			$AnimatedSprite.flip_h = true
		elif direction == 4:
			$AnimatedSprite.animation = "IdleUp"
			$AnimatedSprite.flip_h = false
	
	### SOUNDS ###
	
	if Input.is_action_pressed("walk_all") and $Step.is_stopped():
		var randWalk = randi()%2
		walkSound[randWalk].play()
		$Step.start()

func slow_down(speed,down):
	var nsp = speed
	
	if nsp.x > down:
		nsp.x -= down
	elif nsp.x < -down:
		nsp.x += down
	else:
		nsp.x = 0
	
	if nsp.y > down:
		nsp.y -= down
	elif nsp.y < -down:
		nsp.y += down
	else:
		nsp.y = 0
	
	return nsp