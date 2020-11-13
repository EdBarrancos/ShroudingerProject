extends Node2D

onready var DebugLabel = $DebugLabel;

func setPosition(newPosition):
	set_position(newPosition);
	

func setDebug(properties : Dictionary):
	DebugLabel.text = "";
	for prop in properties:
		DebugLabel.text += str(prop) + " : " + str(properties[prop]) +  "\n";

