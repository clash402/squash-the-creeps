extends Label

# PROPERTIES
var score = 0


# SIGNALS
func _on_Mob_squashed():
	score += 1
	text = "Score: %s" % score
