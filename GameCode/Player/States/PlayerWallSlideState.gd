extends PlayerState

class_name PlayerWallSlideState

var PlayerRunState = load("res://Player/States/PlayerRunState.gd")
var PlayerIdleState = load("res://Player/States/PlayerIdleState.gd")

#Improve: Check if a wall has a specific multiplicator for lowering gravity
#			Check if it drops stamina faster

var rightWall
var gravMultiplier
var currentStamina

func getName():
	return "PlayerWallSlideState"

func enter(player, debugState):
	.enter(player, debugState)
	if debugState: print(getName())
	
	player.setSpeedY(0, 0, false)
	if player.collidingSlidableWallRight(): rightWall = true
	else: rightWall = false
	
	gravMultiplier = player.getWallGrav()
	currentStamina = player.getStamina()

func getInput():
	#Detatch from wall
	if Input.is_action_just_pressed("RIGHT") and not rightWall:
		player.turnRight()
		player.setSpeedX(player.getAirbornMovementAcell()*Input.get_action_strength("RIGHT"), player.getMAXSPEED())
		player.state.setState(PlayerIdleState.new())
	elif Input.is_action_just_pressed("LEFT") and rightWall:
		player.turnLeft()
		player.setSpeedX(-player.getAirbornMovementAcell()*Input.get_action_strength("LEFT"), player.getMAXSPEED())
		player.state.setState(PlayerIdleState.new())
	
	#Wall Jump
	if Input.is_action_just_pressed("UP"): 
		if rightWall:
			player.turnLeft()
			player.setSpeedX(-player.getACELL()*player.getwallSideJumpMulti(), player.getMAXSPEED(), false)
		elif not rightWall:
			player.turnRight()
			player.setSpeedX(player.getACELL()*player.getwallSideJumpMulti(), player.getMAXSPEED(), false)
		player.jump()
	
	#SlowDown WallDecend
	if currentStamina:
		if Input.is_action_pressed("RIGHT") and rightWall:
			player.turnRight()
			gravMultiplier = player.getholdingWallGrav()
			currentStamina -= 1;
		elif Input.is_action_pressed("LEFT") and not rightWall:
			player.turnLeft()
			gravMultiplier = player.getholdingWallGrav()
			currentStamina -= 1;
		else: gravMultiplier = player.getWallGrav()
	else: gravMultiplier = player.getWallGrav()
		
func _physics_process(delta):
	#Check State changes
	if player.is_on_floor():
		player.state.setState(PlayerIdleState.new())
		
	player.applyGravity(gravMultiplier)
	getInput()
	player.movePlayerNormally()
	
