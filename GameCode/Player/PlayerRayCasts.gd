extends Node


onready var rightTop = $RightDetectionTop
onready var rightBot = $RightDetectionBottom
onready var leftTop = $LeftDetectionTop
onready var leftBot = $LeftDetectionBottom


func _ready():
	pass

func setUpInitial():
	rightTop.set_cast_to(Vector2(0, 0))
	rightBot.set_cast_to(Vector2(0, 0))
	leftTop.set_cast_to(Vector2(0, 0))
	leftBot.set_cast_to(Vector2(0, 0))

func setRayCastTo(rightBorder, leftBorder=0):
	rightTop.set_cast_to(Vector2(rightBorder, rightTop.get_cast_to().y))
	rightBot.set_cast_to(Vector2(rightBorder, rightBot.get_cast_to().y))
	leftTop.set_cast_to(Vector2(-rightBorder, leftTop.get_cast_to().y))
	leftBot.set_cast_to(Vector2(-rightBorder, leftBot.get_cast_to().y))
	
	if leftBorder:
		leftTop.set_cast_to(Vector2(leftBorder, leftTop.get_cast_to().y))
		leftBot.set_cast_to(Vector2(leftBorder, leftBot.get_cast_to().y))
		
func collidingRight(): return rightTop.is_colliding() or rightBot.is_colliding()

func collidingLeft(): return leftTop.is_colliding() or leftBot.is_colliding()
