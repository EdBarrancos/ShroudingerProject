extends Node2D

onready var sprite = $Sprite

func _ready():
	pass
	
func dashable():
	sprite.modulate = Color(1,0,0)
	
func approvedForDash():
	sprite.modulate = Color(0,0,1)
	
func notApprovedForDash():
	sprite.modulate = Color(1,1,1)

func get_global_pos(): return global_position
