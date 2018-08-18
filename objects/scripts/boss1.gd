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
	throw_big()

func _physics_process(delta):
	HB.value = life

func throw_big():
	var p = proyectil2.instance()
	p.throw(400,player.position)
	add_child(p)
