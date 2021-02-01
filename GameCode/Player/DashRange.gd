extends Area2D

var currentArea
var lengthOfCurrentArea

onready var rayCast = $RayCastDash
onready var line = $Line2D
onready var debug = false

onready var availableDashables = []
onready var dashEnabled = null


func _ready():
	rayCast.add_exception(owner)


func _physics_process(delta):
	var currentDash
	var challegingDash
	var x = 0
	print(availableDashables)
	if availableDashables.size() >= 2:
		currentDash = setAreaToDash(x, currentDash, rayCast)
		x += 1
		while x < availableDashables.size():
			if currentDash == null:
				currentDash = setAreaToDash(x, currentDash, rayCast)
				print("CurrentDash", currentDash)
			else:
				challegingDash = setAreaToDash(x, challegingDash, rayCast)
				if not isCloserThan(currentDash, challegingDash): currentDash = challegingDash
			x += 1
	dashEnabled = currentDash
	setAreaDashable(dashEnabled)
	setAllToApprovedExcept(dashEnabled)
		
	
func _on_DashRange_area_entered(area):
	print("Entered")
	setAreaApprovedForDash(area)

func _on_DashRange_area_exited(area):
	print("Exited")
	setAreaNotApprovedForDash(area)

##########################
#Area Management##########
##########################

func setAreaToDash(arrayPosition, storeArea, storeRayCast):
	var storeAreaToSet = storeArea
	var storeRayCastToSet = storeRayCast
	storeAreaToSet = availableDashables[arrayPosition]
	
	storeRayCastToSet = setPathToDash(storeAreaToSet, storeRayCastToSet)
	
	if not isPathToDashAvailable(storeRayCastToSet): storeAreaToSet = null

	return storeAreaToSet
	

func isPathToDashAvailable(rayCastToSet = rayCast): return not rayCastToSet.is_colliding()
	
func setPathToDash(area, rayCast):
	var rayCastToSet = rayCast
	rayCastToSet.set_cast_to(area.global_position - global_position)
	if debug: line.set_points([Vector2.ZERO, area.global_position - global_position])
	return rayCastToSet
	
func isCloserThan(currentArea, challegingArea):
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
