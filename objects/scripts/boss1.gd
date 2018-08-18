extends KinematicBody2D

var max_health = 300
var life = 0

export (PackedScene) var proyectil
export (PackedScene) var proyectil2

onready var HB = get_parent().get_node("HUD/Life")
onready var player = get_parent().get_node("Player")

func _ready():
	life = max_health
	HB.max_value = max_health
	

func _physics_process(delta):
	HB.value = life
	throw_big()

func throw_big():
	var p = proyectil2.instance()
	p.position = position
	p.throw(400,player.position)
	get_parent().add_child(p)
