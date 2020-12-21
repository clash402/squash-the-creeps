extends KinematicBody

# PROPERTIES
signal hit

export var speed = 14
export var fall_acceleration = 75
export var jump_impulse = 20
export var bounce_impulse = 16

onready var pivot = $Pivot
onready var anim_player = $AnimationPlayer

var velocity = Vector3.ZERO


# DEFAULTS
func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		pivot.look_at(translation + direction, Vector3.UP)
		anim_player.playback_speed = 4
	else:
		anim_player.playback_speed = 1
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y -= fall_acceleration * delta
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += jump_impulse
	
	velocity = move_and_slide(velocity, Vector3.UP)
	for index in range(get_slide_count()):
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("mob"):
			var mob = collision.collider
			if Vector3.UP.dot(collision.normal) > 0.1:
				velocity.y = bounce_impulse
				mob.squash()
	
	pivot.rotation.x = PI / 6 * velocity.y / jump_impulse


# SIGNALS
func _on_MobDetector_body_entered(body):
	die()


# CUSTOM
func die():
	emit_signal("hit")
	queue_free()




