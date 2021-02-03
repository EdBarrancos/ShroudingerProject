extends Area2D

onready var rayCast = $RayCastDash
onready var line = $DebugLineDashRange
export var debug = false

onready var availableDashables = []
onready var dashEnabled = null

onready var canDash = false #True if there is an object that you can dash too

################################
#Variable Setters and Getters###
################################

#rayCast
func getRayCast(): return rayCast
func setRayCast(newRayCast):
	rayCast = newRayCast
	return rayCast
	
#line
func getLine(): return line
func setLine(newLine):
	line = newLine
	return line
	
#debug
func getDebug(): return debug
func setDegub(newDebug):
	debug = newDebug
	return debug
	
#availableDashables
func getAvailableDashables(): return availableDashables
func setAvailableDashables(newAvailableDashables):
	availableDashables = newAvailableDashables
	return availableDashables
	
#dashEnabled
func getDashEnabled(): return dashEnabled
func setDashEnabled(newDashEnabled):
	dashEnabled = newDashEnabled
	return dashEnabled
	
#canDash
func getCanDash(): return canDash
func setCanDash(newCanDash):
	canDash = newCanDash
	return canDash
	
##################
#Main Functions###
##################

func _ready():
	rayCast.add_exception(owner)


func _physics_process(delta):
	var currentDash
	var challegingDash
	var x = 0
	print(availableDashables)
	if availableDashables.size() >= 1:
		currentDash = setAreaToDash(x, currentDash, rayCast)
		x += 1
		while x < availableDashables.size():
			if currentDash == null: currentDash = setAreaToDash(x, currentDash, rayCast)
			else:
				challegingDash = setAreaToDash(x, challegingDash, rayCast)
				if not isCloserThan(currentDash, challegingDash): currentDash = challegingDash
			x += 1
			
	dashEnabled = currentDash
	
	if dashEnabled != null: canDash = true
	else: canDash = false
	
	setAreaDashable(dashEnabled)
	setAllToApprovedExcept(dashEnabled)
		
##########################
#Area Signal Management###
##########################

func _on_DashRange_area_entered(area):
	if debug: print("Entered")
	setAreaApprovedForDash(area)

func _on_DashRange_area_exited(area):
	if debug: print("Exited")
	setAreaNotApprovedForDash(area)

######################################
#Area And RayCast Management##########
######################################

func setAreaToDash(arrayPosition, storeArea, storeRayCast):
	var storeAreaToSet = storeArea
	var storeRayCastToSet = storeRayCast
	storeAreaToSet = availableDashables[arrayPosition]
	
	storeRayCastToSet = setPathToDash(storeAreaToSet, storeRayCastToSet)
	
	if not isPathToDashAvailable(storeRayCastToSet): storeAreaToSet = null

	return storeAreaToSet
	

func isPathToDashAvailable(rayCast): 
	rayCast.force_raycast_update()
	return not rayCast.is_colliding()
	
func setPathToDash(area, rayCast):
	var rayCastToSet = rayCast
	rayCastToSet.set_cast_to(area.global_position - global_position)
	if debug: line.set_points([Vector2.ZERO, area.global_position - global_position])
	return rayCastToSet
	
func isCloserThan(currentArea, challegingArea):
	if currentArea == null: return false
	if challegingArea == null: return true
	return global_position.distance_to(currentArea.global_position) <= global_position.distance_to(challegingArea.global_position)

##########################
#Object Management########
##########################

func setAreaApprovedForDash(area, add=true):
	if area != null:
		if area.has_method("approvedForDash"):
			area.approvedForDash()
			if add: availableDashables.append(area)
	
func setAreaNotApprovedForDash(area, remove=true):
	if area != null:
		if area.has_method("notApprovedForDash"):
			area.notApprovedForDash()
			if remove: availableDashables.erase(area)
	
func setAreaDashable(area):
	if area != null: if area.has_method("dashable"): area.dashable()
	
func setAllToApprovedExcept(exception=null):
	for item in availableDashables:
		if item != exception:
			setAreaApprovedForDash(item, false)
