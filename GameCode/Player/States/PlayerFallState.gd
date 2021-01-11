extends PlayerState

class_name PlayerFallState

var PlayerRunState = load("res://Player/States/PlayerRunState.gd")
var PlayerIdleState = load("res://Player/States/PlayerIdleState.gd")

func getName():
	return "PlayerFallingState"

func enter(player, debugState):
	.enter(player, debugState)
	if debugState: print(getName())


func getInput():
	if Input.is_action_pressed("RIGHT"):
		player.turnRight()
		player.setSpeedX(player.getAirbornMovementAcell()*Input.get_action_strength("RIGHT"), player.getMAXSPEED())
	elif Input.is_action_pressed("LEFT"):
		player.turnLeft()
		player.setSpeedX(-player.getAirbornMovementAcell()*Input.get_action_strength("LEFT"), player.getMAXSPEED())
	else: player.setSpeedX(player.getAirbornMovementDecell(), 0, false, true)
		
func _physics_process(delta):
	#Check State changes
	if player.is_on_floor():
		player.state.setState(PlayerIdleState.new())
		
	player.applyGravity()
	getInput()
	player.movePlayerNormally()
	
