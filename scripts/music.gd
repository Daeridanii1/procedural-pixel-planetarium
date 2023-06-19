extends AudioStreamPlayer2D

func _process(delta):
	repeat()

func repeat():
	if playing == false:
		play()
