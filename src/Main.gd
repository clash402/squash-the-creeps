extends Node

# PROPERTIES
export (PackedScene) var mob_scene

onready var score_label = $HUD/ScoreLabel
onready var retry = $HUD/Retry
onready var spawn_loc = $SpawnPath/SpawnLoc
onready var player = $Player
onready var mob_timer = $MobTimer


# DEFAULTS
func _ready():
	randomize()
	retry.hide()


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and retry.visible:
		get_tree().reload_current_scene()


# SIGNALS
func _on_MobTimer_timeout():
	var mob = mob_scene.instance()
	spawn_loc.unit_offset = randf()
	var mob_pos = spawn_loc.translation
	var player_pos = player.transform.origin
	add_child(mob)
	mob.spawn(mob_pos, player_pos)
	mob.connect("squashed", score_label, "_on_Mob_squashed")


func _on_Player_hit():
	mob_timer.stop()
	retry.show()
