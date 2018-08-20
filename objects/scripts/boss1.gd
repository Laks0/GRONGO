extends KinematicBody2D

var max_health = 150
var life = 0

export (PackedScene) var proyectil
export (PackedScene) var proyectil2

var fase = 0
var attack = 0
var attacked = 0

var angle1_3 = 0

onready var HB = get_parent().get_node("HUD/Boss/Life")
onready var player = get_parent().get_node("Player")

func _ready():
	life = max_health
	HB.max_value = max_health

func _on_Wait1_2_timeout():
	$Rest.start()

func _on_Wait1_3_timeout():
	$Rest.start()

func _physics_process(delta):
	HB.value = life
	
	if fase == 0:
		if $Rest.is_stopped():
			fase += 1
	elif fase == 1:
		if attack == 0:
			if attacked >= 5:
				if $Rest.is_stopped():
					attack += 1
					$Wait1_2.start()
			elif $Charge1_1.is_stopped():
				if life <= max_health/2:
					var count = 10 #How many proyectiles
					var angle_step = 2*PI / count
					if $Charge1_2.is_stopped():
						var angle = 0
						for i in range(0,count):
							var direction = Vector2(cos(angle), sin(angle))
							var from = position + 50 * direction
							var to = position + 100 * direction
							
							throw_small(from,to)
							
							angle += angle_step
						throw_small(position,player.position)
						$Charge1_2.start()
				attacked += 1
				throw_big()
				if attacked < 5:
					$Charge1_1.start()
				else:
					$Rest.start()
		elif attack == 1:
			if not $Wait1_2.is_stopped():
				var count = 10 #How many proyectiles
				var angle_step = 2*PI / count
				if $Charge1_2.is_stopped():
					var angle = 0
					for i in range(0,count):
						var direction = Vector2(cos(angle), sin(angle))
						var from = position + 50 * direction
						var to = position + 100 * direction
						
						throw_small(from,to)
						
						angle += angle_step
					throw_small(position,player.position)
					$Charge1_2.start()
			elif $Rest.is_stopped():
				attack = 2
				$Wait1_3.start()
		elif attack == 2:
			if not $Wait1_3.is_stopped():
				if $Charge1_3.is_stopped():
					var angle_step = 2*PI / 10 + randf() * 2
					
					var direction = Vector2(cos(angle1_3), sin(angle1_3))
					var from = position + 50 * direction
					var to = position + 100 * direction
					throw_small(from,to)
					
					angle1_3 += angle_step
					
					if randf() < .1:
						throw_small(position,player.position)
					
					$Charge1_3.start()
			elif $Rest.is_stopped():
				attack = 0
				attacked = 0
	
	### ANIMATIONS ###
	if not $Rest.is_stopped():
		$AnimatedSprite.animation = "Idle"
	elif attack == 0:
		$AnimatedSprite.animation = "Atq1"
	else:
		$AnimatedSprite.animation = "Atq2"

func throw_big():
	var p = proyectil2.instance()
	p.position = position
	p.throw(600,player.position)
	get_parent().add_child(p)

func throw_small(from, to):
	var p = proyectil.instance()
	p.position = from
	p.throw(300,to)
	get_parent().add_child(p)
