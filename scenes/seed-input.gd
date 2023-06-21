extends RichTextLabel

var seed_input = ""
var inputting = false
@export var planet = Node3D
var mathutils = MathUtils.new()

func _process(delta):
	if seed_input != "":
		text = "[center]" + seed_input + "[/center]"
	else:
		if !inputting:
			text = "[center]*[/center]"
		else:
			text = "[center][color=FF0000]*[/color][/center]"
	if Input.is_action_just_pressed("seed input") && !inputting:
		inputting = true
	if Input.is_action_just_pressed("seed apply") && inputting:
		inputting = false
		planet.generate(mathutils.base_36_to_int(seed_input))
		seed_input = ""

func _input(event): # Work on this function more later
	if inputting:
		if event is InputEventKey and event.is_pressed():
			if event.keycode == KEY_ENTER:
				pass
			elif event.keycode == KEY_BACKSPACE:
				seed_input.left(-1)
			else:
				seed_input += event.as_text().left(1)
