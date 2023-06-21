extends AudioStreamPlayer2D

var muted = false
var inputting = false

func _process(delta):
	if Input.is_action_just_pressed("seed input"):
		inputting = true
	if Input.is_action_just_pressed("seed apply"):
		inputting = false
	if Input.is_action_just_pressed("mute") && !inputting:
		muted = !muted
		playing = !playing
	repeat()

func repeat():
	if !playing and !muted:
		play()
