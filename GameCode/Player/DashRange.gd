extends Area2D


func _ready():
	pass


func _on_DashRange_area_entered(area):
	print("Entered")
	if area.has_method("approvedForDash"):
		area.approvedForDash()


func _on_DashRange_area_exited(area):
	print("Exited")
	if area.has_method("notApprovedForDash"):
		area.notApprovedForDash()
