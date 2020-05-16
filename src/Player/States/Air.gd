extends State


export var acceleration_x := 5000.0
export var jump_impulse := 900.0
export var max_jump_count := 1

const MAX_COYOTE_TIME_FRAME := 4

var _jump_count := 0
var _coyote_time_buffer := 0


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		if _jump_count <= max_jump_count or _coyote_time_buffer > 0:
			jump()

	_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
	_coyote_time_buffer -= 1

	# Landing
	if owner.is_on_floor():
		var target_state: = "Move/Idle" if _parent.get_move_direction().x == 0 else "Move/Run"
		_state_machine.transition_to(target_state)


func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)

	_parent.acceleration.x = acceleration_x
	if "coyote_time" in msg:
		_coyote_time_buffer = MAX_COYOTE_TIME_FRAME
	if "impulse" in msg:
		print("impulse")
		jump()


func exit() -> void:
	_jump_count = 0
	_coyote_time_buffer = 0
	_parent.acceleration = _parent.acceleration_default
	_parent.exit()


func jump() -> void:
	_parent.velocity.y = 0
	_parent.velocity += calculate_jump_velocity(jump_impulse)
	_jump_count += 1


# Returns a new velocity with a vertical impulse applied to it
func calculate_jump_velocity(impulse: float = 0.0) -> Vector2:
	return _parent.calculate_velocity(
		_parent.velocity,
		_parent.max_speed,
		Vector2(0.0, impulse),
		Vector2.ZERO,
		1.0, # replace delta
		Vector2.UP
	)
