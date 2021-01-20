extends PlayerState

class_name PlayerWallSlideState

var PlayerRunState = load("res://Player/States/PlayerRunState.gd")
var PlayerIdleState = load("res://Player/States/PlayerIdleState.gd")

var rightWall

func getName():
	return "PlayerWallSlideState"

func enter(player, debugState):
	.enter(player, debugState)
	if debugState: print(getName())
	
	player.setSpeedY(0, 0, false)
	if player.collidingSlidableWallRight(): rightWall = true
	else: rightWall = false

func getInput():
	if Input.is_action_just_pressed("RIGHT") and rightWall:
		player.turnRight()
		player.setSpeedX(player.getAirbornMovementAcell()*Input.get_action_strength("RIGHT"), player.getMAXSPEED())
		player.state.setState(PlayerIdleState.new())
	elif Input.is_action_just_pressed("LEFT") and not rightWall:
		player.turnLeft()
		player.setSpeedX(-player.getAirbornMovementAcell()*Input.get_action_strength("LEFT"), player.getMAXSPEED())
		player.state.setState(PlayerIdleState.new())
		
func _physics_process(delta):
	#Check State changes
	if player.is_on_floor():
		player.state.setState(PlayerIdleState.new())
		
	player.applyWallGravity()
	getInput()
	player.movePlayerNormally()
	
