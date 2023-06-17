extends MultiMeshInstance3D

@export var count : int = 100
@export var cloud_mesh : Mesh

# Called when the node enters the scene tree for the first time.
func _ready():
	var pts = generate_cloud_points(25, 8, 2, 0.5, 0.15)
	var mm = MultiMesh.new()
	mm.mesh = cloud_mesh
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.instance_count = pts.size() - 1
	self.multimesh = mm
	for i in multimesh.instance_count:
		var t = mm.get_instance_transform(i)
		mm.set_instance_transform(i, Transform3D(Basis(), pts[i] * 0.6))

func rand_on_unit_sphere():
	var x1 = randf_range (-1, 1)
	var x2 = randf_range (-1, 1)
	while x1*x1 + x2*x2 >= 1:
		x1 = randf_range (-1, 1)
		x2 = randf_range (-1, 1)
	var random_pos_on_unit_sphere = Vector3 (2 * x1 * sqrt (1 - x1*x1 - x2*x2), 2 * x2 * sqrt (1 - x1*x1 - x2*x2), 1 - 2 * (x1*x1 + x2*x2))
	return random_pos_on_unit_sphere

func generate_cloud_points(base: float, children: float, grandchildren: float, offspring_chance: float, dispersion: float):
	var list = []
	for i in base:
		var i_r = rand_on_unit_sphere()
		list.append(i_r)
		for j in children:
			if randf() < offspring_chance:
				var j_r = i_r + Vector3(randf_range(-1 * dispersion, dispersion), randf_range(-1 * dispersion, dispersion), randf_range(-1 * dispersion, dispersion))
				list.append(j_r)
				for k in grandchildren:
					if randf() < offspring_chance:
						list.append(j_r + Vector3(randf_range(-1 * dispersion, dispersion), randf_range(-1 * dispersion, dispersion), randf_range(-1 * dispersion, dispersion)))
	for i in list.size() - 1:
		list[i] = list[i].normalized()
	return list
