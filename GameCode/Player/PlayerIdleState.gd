extends PlayerState

class_name PlayerIdleState

var PlayerRunState = load("res://Player/PlayerRunState.gd")


func getName():
	return "PlayerIdleState"

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
		self.player.state.setState(PlayerRunState.new())
	elif Input.is_action_pressed("ui_left"):
		if not isSpriteFilliped():
			flipDirection()
		self.player.state.setState(PlayerRunState.new())
		
func _physics_process(delta):
	getInput()
