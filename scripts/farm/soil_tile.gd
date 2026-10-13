class_name SoilTile
extends RefCounted

enum State {
	EMPTY,
	TILLED,
	PLANTED,
}

signal state_changed(from_state: State, to_state: State)

var state: State = State.EMPTY


func till() -> bool:
	if state != State.EMPTY:
		return false
	var from := state
	state = State.TILLED
	state_changed.emit(from, state)
	return true


func plant() -> bool:
	if state != State.TILLED:
		return false
	var from := state
	state = State.PLANTED
	state_changed.emit(from, state)
	return true
