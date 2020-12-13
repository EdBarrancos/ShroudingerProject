extends PlayerState

class_name PlayerRunState

var PlayerIdleState = load("res://Player/PlayerIdleState.gd")

var velocity = Vector2.ZERO
var walkSpeed = 200

func getName():
	return "PlayerRunState"

func enter(player):
	.enter(player)
	print(getName())

func isSpriteFilliped():
	return self.player.sprite.flip_h
	
func flipDirection():
	self.player.sprite.flip_h = not self.player.sprite.flip_h

func getInput():
	if Input.is_action_pressed("ui_right"):
		if isSpriteFilliped():
			flipDirection()
		velocity.x = walkSpeed
	elif Input.is_action_pressed("ui_left"):
		if not isSpriteFilliped():
			flipDirection()
		velocity.x = -walkSpeed
	else:
		self.player.state.setState(PlayerIdleState.new())
		

func _physics_process(delta):
	getInput()
	var movement = velocity*delta
	self.player.move_and_collide(movement)
