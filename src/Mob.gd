extends KinematicBody

# PROPERTIES
signal squashed

export var min_speed = 10
export var max_speed = 18

onready var anim_player = $AnimationPlayer

var velocity = Vector3.ZERO


# DEFAULTS
func _physics_process(delta):
	move_and_slide(velocity)


# SIGNALS
func _on_VisibilityNotifier_screen_exited():
	queue_free()


# CUSTOM
func spawn(spawn_pos, player_pos):
	translation = spawn_pos
	look_at(player_pos, Vector3.UP)
	rotate_y(rand_range(-PI / 4, PI / 4))
	
	var random_speed = rand_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	
	anim_player.playback_speed = random_speed / min_speed


func squash():
	emit_signal("squashed")
	queue_free()




