extends Area2D

var currentArea
var lengthOfCurrentArea

onready var rayCast = $RayCastDash
onready var line = $Line2D

onready var availableDashables = []


func _ready():
	rayCast.add_exception(owner)


func _physics_process(delta):
	print(availableDashables)
	if availableDashables.size() >= 1:
		var closestDash = availableDashables[0]
		rayCast.set_cast_to(closestDash.global_position - global_position)
		line.set_points([Vector2.ZERO, closestDash.global_position - global_position])
		print(rayCast.get_collider())
	
	
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
