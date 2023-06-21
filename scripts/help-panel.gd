extends RichTextLabel

var inputting = false

func _process(delta):
	if Input.is_action_just_pressed("seed input"):
		inputting = true
	if Input.is_action_just_pressed("seed apply"):
		inputting = false
	if Input.is_action_just_pressed("help") && !inputting:
		visible = !visible
