extends KinematicBody2D

var state 
onready var sprite = $Sprite

func _ready():
	# Initialize state.
	state = PlayerIdleState.new()
	state.enter(self)
	add_child(state)

#input and changing state is handled by the states themselves

# Let the current state handle the processing logic; also handle the changing of states.
func _physics_process(delta):
	# Update the current state; handle switching.
	state.call("_physics_process", delta)

