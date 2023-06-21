extends Node3D

var inputting = false

func _process(delta):
	if Input.is_action_just_pressed("seed input"):
		inputting = true
	if Input.is_action_just_pressed("seed apply"):
		inputting = false
	if Input.is_action_just_pressed("quit") && !inputting:
		get_tree().get_root().propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()
	if Input.is_action_just_pressed("fullscreen") && !inputting:
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
