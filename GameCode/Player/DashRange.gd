extends Area2D

var currentArea
var lengthOfCurrentArea

onready var rayCast = RayCast2D

onready var availableDashables = []


func _ready():
	pass


func _physics_process(delta):
	print(availableDashables)
	var x = 0
	
	
	
func _on_DashRange_area_entered(area):
	print("Entered")
	if area.has_method("approvedForDash"):
		area.approvedForDash()
		availableDashables.append(area)


func _on_DashRange_area_exited(area):
	print("Exited")
	if area.has_method("notApprovedForDash"):
		area.notApprovedForDash()
		availableDashables.erase(area)
