extends Node2D


onready var deb = load("./Debugger/Debugger.tscn")
onready var debInstance = deb.instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(debInstance)
	debInstance.setPosition(Vector2(100,100))



func _process(delta):
	debInstance.setDebug({"name" : "Eduardo", "agr" : 18})
