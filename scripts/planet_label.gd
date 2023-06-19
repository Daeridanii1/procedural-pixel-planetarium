extends RichTextLabel

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = round(get_viewport().get_visible_rect().size.x * 0.6)
	position.y = round(get_viewport().get_visible_rect().size.y * 0.33)
	size.x = get_viewport().get_visible_rect().size.x * 0.35
	
	theme.default_font_size = snapped(get_viewport().get_visible_rect().size.x / 51., 2)
