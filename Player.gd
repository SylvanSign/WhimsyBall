extends KinematicBody2D

export(int) var ACCELERATION := 600
export(int) var MAX_SPEED := 800
export(int) var FRICTION := 10

var velocity: Vector2

func _physics_process(delta: float) -> void:
	var input := Vector2(
		Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left'),
		Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up')
	).normalized()

	velocity += input * ACCELERATION * delta
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = velocity.clamped(MAX_SPEED)

	velocity = move_and_slide(velocity)
