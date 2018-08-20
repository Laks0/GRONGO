extends KinematicBody2D

export (int) var MAX_SPEED = 500
export (float) var acceleration = 50
export (float) var FRICTION = 20

#Im not sure if this is A LOT OF DAMAGE
var damage = 20
var movement = Vector2()

var attacking = false

var direction = 2
var dir

onready var walkSound = [
	$Walk1,
	$Walk2
]

var life = 0

onready var HB = get_parent().get_node("HUD/Player/Life")

func _ready():
	life = 3
	HB.max_value = life

func _physics_process(delta):
	HB.value = life
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
		attacking = true
		$MeleeCool.start()
		
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
	
	if attacking:
		if $AnimatedSprite.frame == 2:
			if dir.is_colliding():
				$Punch.play()
				var col = dir.get_collider()
				if col.is_in_group("Boss"):
					col.life -= damage
					var knockback = 15
					movement += (position - col.position) * knockback
			
			$AnimatedSprite.frame = 3
			$MeleeCool.start()
		elif $AnimatedSprite.frame == 5:
			attacking = false
	
	
	### DAMAGE ###
	for r in get_tree().get_nodes_in_group("Hit"):
			r.enabled = true
			if r.is_colliding():
				var col = r.get_collider()
				if col.is_in_group("Enemy"):
					col.get_parent().remove_child(col)
					if $Invensibility.is_stopped():
						life -= 1
						$Invensibility.start()
						break
	if $Invensibility.is_stopped():
		$AnimatedSprite.modulate = Color(1,1,1,1)
	else:
		$AnimatedSprite.modulate = Color(1,1,1,.5)
	
	### ANIMATIONS ###
	
	if attacking:
		if direction == 1:
			$AnimatedSprite.animation = "PunchRight"
			$AnimatedSprite.flip_h = false
		elif direction == 2:
			$AnimatedSprite.animation = "PunchDown"
			$AnimatedSprite.flip_h = false
		elif direction == 3:
			$AnimatedSprite.animation = "PunchRight"
			$AnimatedSprite.flip_h = true
		elif direction == 4:
			$AnimatedSprite.animation = "PunchUp"
			$AnimatedSprite.flip_h = false
	elif movement == Vector2(0,0):
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
	else:
		if Input.is_action_just_pressed("right"):
			$AnimatedSprite.animation = "WalkRight"
			$AnimatedSprite.flip_h = false
		elif Input.is_action_just_pressed("down"):
			$AnimatedSprite.animation = "WalkDown"
			$AnimatedSprite.flip_h = false
		elif Input.is_action_just_pressed("left"):
			$AnimatedSprite.animation = "WalkRight"
			$AnimatedSprite.flip_h = true
		elif Input.is_action_just_pressed("up"):
			$AnimatedSprite.animation = "WalkUp"
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
