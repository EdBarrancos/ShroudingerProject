extends PlayerState

class_name PlayerJumpState

var PlayerRunState = load("res://Player/States/PlayerRunState.gd")
var PlayerIdleState = load("res://Player/States/PlayerIdleState.gd")
var PlayerFallState = load("res://Player/States/PlayerFallState.gd")

func getName():
	return "PlayerJumpState"

func enter(player, debugState):
	.enter(player, debugState)
	player.setForcedJumped(0)
	if debugState: print(getName())


func getInput():
	#Horizontal
	if Input.is_action_pressed("RIGHT"):
		player.turnRight()
		player.setSpeedX(player.getAirbornMovementAcell()*Input.get_action_strength("RIGHT"), player.getMAXSPEED())
	elif Input.is_action_pressed("LEFT"):
		player.turnLeft()
		player.setSpeedX(-player.getAirbornMovementAcell()*Input.get_action_strength("LEFT"), player.getMAXSPEED())
	else: player.setSpeedX(player.getAirbornMovementDecell(), 0, false, true)
	
	#Vertical
	if Input.is_action_pressed("UP"): player.jump(true)
	else: player.state.setState(PlayerFallState.new())
	
	if player.canDash() and Input.is_action_just_pressed("DASH"):
		player.state.setState(PlayerDashState.new())
		
func _physics_process(delta):
	#Check for state changes
	if player.is_on_floor(): player.state.setState(PlayerIdleState.new())
	#if player.collidingSlidableWall(): player.state.setState(PlayerWallSlideState.new())
		
	player.applyGravity()
	getInput()
	player.movePlayerNormally()
