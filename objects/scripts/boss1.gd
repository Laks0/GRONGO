extends KinematicBody2D

var max_health = 150
var life = 0

onready var HB = get_parent().get_node("HUD/Life")

func _ready():
	life = max_health

func _physics_process(delta):
	HB.max_value = max_health
	HB.value = life