extends KinematicBody2D

onready var sprite = $Sprite
onready var collision = $CollisionShape2D
onready var rayCasts = $PlayerRayCasts
onready var dashRange = $DashRange

var state 
enum states {IDLE, RUNNING, FALLING, JUMPING}


var UP = Vector2(0, -1)
export var Grav = 12
export var MAXFALLSPEED = 230
export var JUMPFORCE = -150
export var JUMPACELL = -30
var ForcedJumped = 0
export var JUMPTICKSFALLTHROUGH = 10
export var MAXFALLWALLSPEED = 30

export var wallGrav = 0.4
export var holdingWallGrav = 0.05
export var stamina = 100
var currentStamina = 100

export var dashVelocityModule = 20

export var AirbornAcellFactor = 0.7
export var AirbornDecellFactor = 0.7

export var MAXSPEED = 150
export var ACELL = 100
export var wallSideJumpMulti = 20
export var velocity = Vector2.ZERO
export var DECELL = 0.4


func _ready():
	# Initialize state.
	state = PlayerIdleState.new()
	state.enter(self, false)
	add_child(state)
	
	#Set up RayCasts
	rayCastSetting()

#input and changing state is handled by the states themselves

# Let the current state handle the processing logic; also handle the changing of states.
func _physics_process(delta):
	# Update the current state; handle switching.
	state.call("_physics_process", delta)
	
	
################################
#Variable Setters and Getters###
################################

#Extra
func get_global_pos(): return global_position

#UP
func getUP(): return UP
func setUP(newUP): 
	UP = newUP
	return UP
	
#Grav
func getGrav(): return Grav
func setGrav(newGrav): 
	Grav = newGrav
	return Grav
	
#wallGrav
func getWallGrav(): return wallGrav
func setWallGrav(newWallGrav):
	wallGrav = newWallGrav
	return wallGrav

#holdingWallGrav
func getholdingWallGrav(): return holdingWallGrav
func setholdingWallGrav(newholdingWallGrav):
	holdingWallGrav = newholdingWallGrav
	return holdingWallGrav
	
#stamina
func getStamina(): return stamina
func setStamina(newStamina):
	stamina = newStamina
	return stamina

#currentStamina
func getcurrentStamina(): return currentStamina
func setcurrentStamina(newcurrentStamina):
	currentStamina = newcurrentStamina
	return currentStamina

#MAXFALLSPEED
func getMAXFALLSPEED(): return MAXFALLSPEED
func setMAXFALLSPEED(newMAXFALLSPEED):
	MAXFALLSPEED = newMAXFALLSPEED
	return MAXFALLSPEED
	
#MAXFALLWALLSPEED
func getMAXFALLWALLSPEED(): return MAXFALLWALLSPEED
func setMAXFALLWALLSPEED(newMAXFALLWALLSPEED):
	MAXFALLWALLSPEED = newMAXFALLWALLSPEED
	return MAXFALLWALLSPEED
	
#JUMPFORCE
func getJUMPFORCE(): return JUMPFORCE
func setJUMPFORCE(newJUMPFORCE):
	JUMPFORCE = newJUMPFORCE
	return JUMPFORCE
	
#JUMPACELL
func getJUMPACELL(): return JUMPACELL
func setJUMPACELL(newJUMPACELL):
	JUMPACELL = newJUMPACELL
	return JUMPACELL
	
#ForcedJumped
func getForcedJumped(): return ForcedJumped
func setForcedJumped(newForcedJumped):
	ForcedJumped = newForcedJumped
	return ForcedJumped
	
#JUMPTICKSFALLTHROUGH
func getJUMPTICKSFALLTHROUGH(): return JUMPTICKSFALLTHROUGH
func setJUMPTICKSFALLTHROUGH(newJUMPTICKSFALLTHROUGH):
	JUMPTICKSFALLTHROUGH = newJUMPTICKSFALLTHROUGH
	return JUMPTICKSFALLTHROUGH

#AirbornAcellFactor
func getAirbornAcellFactor(): return AirbornAcellFactor
func setAirbornAcellFactor(newAirbornAcellFactor):
	AirbornAcellFactor = newAirbornAcellFactor
	return AirbornAcellFactor
	
#AirbornDecellFactor
func getAirbornDecellFactor(): return AirbornDecellFactor
func setAirbornDecellFactor(newAirbornDecellFactor):
	AirbornDecellFactor = newAirbornDecellFactor
	return AirbornDecellFactor

#MAXSPEED
func getMAXSPEED(): return MAXSPEED
func setMAXSPEED(newMAXSPEED):
	MAXSPEED = newMAXSPEED
	return MAXSPEED

#ACELL
func getACELL(): return ACELL
func setACELL(newACELL):
	ACELL = newACELL
	return ACELL
	
#wallSideJumpMulti
func getwallSideJumpMulti(): return wallSideJumpMulti
func setwallSideJumpMulti(newwallSideJumpMulti):
	wallSideJumpMulti = newwallSideJumpMulti;
	return wallSideJumpMulti

#velocity
func getvelocity(): return velocity
func setvelocity(newvelocity):
	velocity = newvelocity
	return velocity

#DECELL
func getDECELL(): return DECELL
func setDECELL(newDECELL):
	DECELL = newDECELL
	return DECELL

#dashVelocityModule
func getDashVelocityModule(): return dashVelocityModule
func setDashVelocityModule(newDashVelocityModule):
	dashVelocityModule = newDashVelocityModule
	return dashVelocityModule

################################
#Animation Handling
################################

func isSpriteFilliped():
	return sprite.flip_h
	
func flipDirection():
	sprite.flip_h = not sprite.flip_h

func turnRight():
	if isSpriteFilliped():
			flipDirection()

func turnLeft():
	if not isSpriteFilliped():
			flipDirection()

########################################
#Movement Handling
########################################

func movePlayerNormally():
	setvelocity(move_and_slide(getvelocity(), getUP()))
	
func getAirbornMovementAcell(): return getACELL()*getAirbornAcellFactor()
func getAirbornMovementDecell(): return getDECELL()*getAirbornDecellFactor()

func setSpeedX(value, maxvalue=0, adding=true, gradual=false):
	if!gradual:
		if adding: 
			velocity.x += value
		else: velocity.x = value
		
		if maxvalue: velocity.x = clamp(velocity.x, -maxvalue, maxvalue)
	else: velocity.x = lerp(velocity.x, maxvalue, value)
	return velocity
	
func setSpeedY(value, maxvalue=0, adding=true, gradual=false):
	if !gradual:
		if adding: 
			velocity.y += value
		else: velocity.y = value
		
		if maxvalue: velocity.y = clamp(velocity.y, -maxvalue, maxvalue)
	else: velocity.y = lerp(velocity.y, maxvalue, value)
	return velocity
	
func jump(fallthrough=false):
	if !fallthrough:
		setSpeedY(JUMPFORCE, 0, false)
		state.setState(PlayerJumpState.new())
	else:
		setSpeedY(JUMPACELL)
		ForcedJumped -= JUMPACELL
		if ForcedJumped >= (-JUMPACELL)*JUMPTICKSFALLTHROUGH:
			ForcedJumped = 0
			state.setState(PlayerFallState.new())
			
func applyGravity(multiplier=1):
	setSpeedY(Grav*multiplier, MAXFALLSPEED*multiplier)
	
func collidingSlidableWall(): return rayCasts.collidingLeft() or rayCasts.collidingRight()

func collidingSlidableWallRight(): return rayCasts.collidingRight()
func collidingSlidableWallLeft(): return rayCasts.collidingLeft()
	
##############################
#Auxiliary Stuff
##############################

func getValueSign(value):
	if value > 0: return 1
	elif value < 0: return -1
	else: return 0
	
func rayCastSetting():
	rayCasts.setRayCastTo(sprite.texture.get_width()/4)
	
########################
#Stamina Management#####
########################
	
func subtractCurrentStamina(value=1):
	currentStamina -= value
	return currentStamina

func resetCurrentStamina():
	currentStamina = stamina
	return currentStamina

#####################
#Dash Management#####
#####################

func canDash(): return dashRange.getCanDash()
func dashToObject(): return dashRange.getDashEnabled()

func distanceToDashObject(dashAble): return get_global_pos().distance_to(dashAble.get_global_pos()) 
