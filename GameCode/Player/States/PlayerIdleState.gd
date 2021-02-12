extends PlayerState

class_name PlayerIdleState

var PlayerRunState = load("res://Player/States/PlayerRunState.gd")
var PlayerFallState = load("res://Player/States/PlayerFallState.gd")

func getName():
	return "PlayerIdleState"

func enter(player, debugState):
	.enter(player, debugState)
	if debugState: print(getName())
	
	player.resetCurrentStamina()


func getInput():
	if Input.is_action_pressed("RIGHT"):
		player.turnRight()
		player.state.setState(PlayerRunState.new())
	elif Input.is_action_pressed("LEFT"):
		player.turnLeft()
		player.state.setState(PlayerRunState.new())
	else: player.setSpeedX(player.getDECELL(), 0, false, true)
		
	if Input.is_action_just_pressed("UP"):
		self.player.jump()
		
	if player.canDash() and Input.is_action_just_pressed("DASH"):
		player.state.setState(PlayerDashState.new())
		
func _physics_process(_delta):
	#Check for state changes
	if !player.is_on_floor(): player.state.setState(PlayerFallState.new())
	
	player.applyGravity()
	getInput()
	player.movePlayerNormally()
	
