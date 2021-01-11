extends KinematicBody2D

onready var sprite = $Sprite

var state 
enum states {IDLE, RUNNING, FALLING, JUMPING}


var UP = Vector2(0, -1)
export var Grav = 40
export var MAXFALLSPEED = 200
export var JUMPFORCE = -450
export var JUMPACELL = -60
var ForcedJumped = 0
export var JUMPTICKSFALLTHROUGH = 6

export var AirbornAcellFactor = 1.5
export var AirbornDecellFactor = 0.75

export var MAXSPEED = 200
export var ACELL = 30
export var velocity = Vector2.ZERO
export var DECELL = 0.4


func _ready():
	#state = states.IDLE
	# Initialize state.
	state = PlayerIdleState.new()
	state.enter(self)
	add_child(state)

#input and changing state is handled by the states themselves

# Let the current state handle the processing logic; also handle the changing of states.
func _physics_process(delta):
	# Update the current state; handle switching.
	state.call("_physics_process", delta)


################################
#Variable Setters and Getters
################################

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
	
#MAXFALLSPEED
func getMAXFALLSPEED(): return MAXFALLSPEED
func setMAXFALLSPEED(newMAXFALLSPEED):
	MAXFALLSPEED = newMAXFALLSPEED
	return MAXFALLSPEED
	
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
		
		if maxvalue: velocity.x = clamp(velocity.x, -maxvalue, maxvalue)
	else: velocity.y = lerp(velocity.y, maxvalue, value)
	return velocity
	
func jump(fallthrough=false):
	if !fallthrough:
		setSpeedY(JUMPFORCE, 0, false)
		state.setState(PlayerJumpState.new())
	else:
		print("Fallingthrough")
		setSpeedY(JUMPACELL)
		ForcedJumped -= JUMPACELL
		if ForcedJumped >= (-JUMPACELL)*JUMPTICKSFALLTHROUGH:
			ForcedJumped = 0
			state.setState(PlayerFallState.new())
			
func applyGravity():
	setSpeedY(Grav, MAXFALLSPEED)
	
	

##############################
#Auxiliary Stuff
##############################

func getValueSign(value):
	if value > 0: return 1
	elif value < 0: return -1
	else: return 0
