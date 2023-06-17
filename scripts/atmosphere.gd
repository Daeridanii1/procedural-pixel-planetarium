extends Sprite3D

@export var target : Node3D
@export var base_scale = 0.118

func _process(delta):
	scale = target.scale * Vector3(base_scale, base_scale, base_scale)
