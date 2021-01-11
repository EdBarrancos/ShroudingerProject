extends PlayerState

class_name PlayerRunState

var PlayerIdleState = load("res://Player/States/PlayerIdleState.gd")

var velocity = Vector2.ZERO
var walkSpeed = 200

func getName():
	return "PlayerRunState"

func enter(player, debugState):
	.enter(player, debugState)
	if debugState: print(getName())

func getInput():
	if Input.is_action_pressed("RIGHT"):
		player.turnRight()
		player.setSpeedX(player.getACELL()*Input.get_action_strength("RIGHT"), player.getMAXSPEED())
	elif Input.is_action_pressed("LEFT"):
		player.turnLeft()
		player.setSpeedX(-player.getACELL()*Input.get_action_strength("LEFT"),player.getMAXSPEED())
	else:
		player.state.setState(PlayerIdleState.new())
		player.setSpeedX(player.getDECELL(), 0, false, true)
		
	if Input.is_action_just_pressed("UP"): player.jump()
		

func _physics_process(delta):
	#Check for state changes
	if !player.is_on_floor(): player.state.setState(PlayerFallState.new())
		
	player.applyGravity()
	getInput()
	player.movePlayerNormally()
	
	
