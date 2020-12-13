extends Node

class_name PlayerState

# Superclass (faux interface) common to all finite state machine / pushdown automata.

var player

# Return the unique string name of the state. Must be overridden.
func getName():
	assert(false)

# Handle any transitions into this state. Subclasses should first chain to this method.
func enter(player):
	self.player = player

# Exit the current state, enter a new one.
func setState(state):
	player.state.exit()
	player.state.queue_free()
	player.state = state
	state.enter(player)
	player.add_child(state)

# Handle input events.
func getInput():
	pass

func _physics_process(delta):
	pass

# Handle exit events.
func exit():
	pass
