extends PlayerState

class_name PlayerDashState

var PlayerRunState = load("res://Player/States/PlayerRunState.gd")
var PlayerIdleState = load("res://Player/States/PlayerIdleState.gd")
var PlayerFallState = load("res://Player/States/PlayerFallState.gd")

var dashTo
var dashVelocity
var initialDistance

func getName():
	return "PlayerDashState"

func enter(player, debugState):
	.enter(player, debugState)
	print(getName())
	if player.canDash(): dashTo = player.dashToObject()
	else: player.state.setState(PlayerIdleState.new())
	player.collision.set_disabled(true)
	dashVelocity = (player.get_global_pos().direction_to(dashTo.get_global_pos()))
	initialDistance = player.distanceToDashObject(dashTo)
	if debugState: print(getName())
	
func exit():
	player.collision.set_disabled(false)

		
func _physics_process(delta):
	#Check for state changes
	#if player.collidingSlidableWall(): player.state.setState(PlayerWallSlideState.new())
	player.setSpeedX(dashVelocity.x  * player.getDashVelocityModule(), 0, false, false)
	player.setSpeedY(dashVelocity.y  * player.getDashVelocityModule(), 0, false, false)
	
	player.movePlayerNormally()
	if player.get_slide_count():
		player.state.setState(PlayerIdleState.new())
	
	if player.distanceToDashObject(dashTo) < 5:
		player.collision.set_disabled(false)
	if player.distanceToDashObject(dashTo) > initialDistance:
		player.state.setState(PlayerIdleState.new())
