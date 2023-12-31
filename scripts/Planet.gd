extends CSGSphere3D

@export var rotation_speed: float = 0.1

@export var base_noise_tex : NoiseTexture2D
@export var craters_tex : NoiseTexture2D
@export var stripes_tex : NoiseTexture2D
@export var clouds : Node3D
@export var atmosphere : Sprite3D
@export var aurora : Node3D
@export var pring : Node3D
@export var label : RichTextLabel

var base_noise: FastNoiseLite = FastNoiseLite.new()
var craters: FastNoiseLite = FastNoiseLite.new()

var is_gas_giant = false
var type
var temp
var atmo
var ring
enum ATMO {NONE, TENUOUS, AVERAGE, THICK}
enum TEMP {VERY_HOT, HOT, TEMPERATE, COLD, VERY_COLD}
enum PTYPE {SELENA, TERRA, GAS_GIANT}

const THIRTYTWOLIMIT = 4294967295

var namesfile_data
var flavorfile_data

var rng = RandomNumberGenerator.new()
var mathutils = MathUtils.new()

func _ready():
	rng.seed = 0
	load_namesfile()
	load_flavorfile()
	generate(0)

func _process(delta):
	rotate(Vector3(0.0, 1.0, 0.0), rotation_speed * delta)
	if Input.is_action_just_pressed("generate"):
		generate()
		generate_text()
	if Input.is_action_pressed("left"):
		rotate(Vector3(0.0, 1.0, 0.0), rotation_speed * delta * 10.)
	if Input.is_action_pressed("right"):
		rotate(Vector3(0.0, 1.0, 0.0), rotation_speed * delta * -10.)

func generate(seed: int = -1, planet_type: int = -1, planet_temp: int = -1):
	if seed == -1:
		rng.seed = randi()
	elif seed < -1:
		rng.seed = abs(seed)
	else:
		rng.seed = seed

	if rng.randf() < 0.05:
		ring = true
		pring.visible = true
	else:
		ring = false
		pring.visible = false
	if rng.randf() < 0.2:
		is_gas_giant = true
	else: 
		is_gas_giant = false
	
	if is_gas_giant:
		atmo = ATMO.THICK
		type = PTYPE.GAS_GIANT
	else:
		atmo = rng.randi_range(0, ATMO.size() - 1)
		type = rng.randi_range(0, PTYPE.size() - 1)
	temp = rng.randi_range(0, TEMP.size() - 1)
	
	randomize_noise()
	set_instance_shader_parameter("color_shadow", Vector4(0.0, 0.0, 0.2, 1.0))
	
	var sc = 1.0
	if is_gas_giant:
		sc = rng.randf_range(1.4, 2.0)
	else:
		sc = rng.randf_range(0.8, 1.2)
	scale = Vector3(sc, sc, sc)
	
	match type:
		PTYPE.SELENA:
			match temp:
				TEMP.VERY_HOT:
					generate_selena()
				TEMP.HOT:
					generate_selena()
				TEMP.TEMPERATE:
					generate_selena()
				TEMP.COLD:
					generate_selena()
				TEMP.VERY_COLD:
					generate_selena()
		PTYPE.TERRA:
			match temp:
				TEMP.VERY_HOT:
					generate_terra(0)
				TEMP.HOT:
					generate_terra(1)
				TEMP.TEMPERATE:
					generate_terra(2)
				TEMP.COLD:
					generate_terra(3)
				TEMP.VERY_COLD:
					generate_terra(4)
		PTYPE.GAS_GIANT:
			match temp:
				TEMP.VERY_HOT:
					generate_gg()
				TEMP.HOT:
					generate_gg()
				TEMP.TEMPERATE:
					generate_gg()
				TEMP.COLD:
					generate_gg()
				TEMP.VERY_COLD:
					generate_gg()
	generate_text()

func generate_selena():
	clouds.visible = false
	atmosphere.visible = false
	aurora.visible = false
	set_instance_shader_parameter("color0", mathutils.random_white(rng, 0.0, 0.1))
	set_instance_shader_parameter("color1", mathutils.random_white(rng, 0.0, 0.15))
	set_instance_shader_parameter("color1", mathutils.random_white(rng, 0.0, 0.25))
	set_instance_shader_parameter("color1", mathutils.random_white(rng, 0.0, 0.5))
	set_instance_shader_parameter("color1", mathutils.random_white(rng, 0.0, 1.0))
	set_instance_shader_parameter("noise_mult", randf_range(0.2, 0.6))
	set_instance_shader_parameter("crater_mult", randf_range(0.8, 2.0))
	set_instance_shader_parameter("poles_mult", 0.0)
	material.set_shader_parameter("NOISE_PATTERN", base_noise_tex)
	material.set_shader_parameter("VORONOI_PATTERN", craters_tex)

func generate_terra(temperature : int = 2):
	clouds.visible = true
	atmosphere.visible = true
	aurora.visible = true
	set_instance_shader_parameter("color0", mathutils.random_blue(rng, 2.0, 0.5))
	set_instance_shader_parameter("color1", mathutils.random_blue(rng, 1.0, 1.2))
	set_instance_shader_parameter("color2", mathutils.random_green(rng))
	set_instance_shader_parameter("color3", mathutils.random_green(rng))
	set_instance_shader_parameter("color4", mathutils.random_white(rng))
	match temperature:
		TEMP.VERY_HOT, TEMP.HOT:
			set_instance_shader_parameter("color0", mathutils.random_red(rng, 2.0, 0.5))
			set_instance_shader_parameter("color1", mathutils.random_red(rng, 1.0, 1.2))
			set_instance_shader_parameter("color2", mathutils.random_red(rng))
			set_instance_shader_parameter("color3", mathutils.random_red(rng))
			set_instance_shader_parameter("color4", mathutils.random_red(rng))
			set_instance_shader_parameter("poles_mult", 0.0)
		TEMP.COLD:
			set_instance_shader_parameter("poles_mult", 2.0)
		TEMP.VERY_COLD:
			set_instance_shader_parameter("color0", mathutils.random_white(rng, 2.0, 0.5))
			set_instance_shader_parameter("color1", mathutils.random_white(rng, 1.0, 1.2))
			set_instance_shader_parameter("color2", mathutils.random_white(rng))
			set_instance_shader_parameter("color3", mathutils.random_white(rng))
			set_instance_shader_parameter("poles_mult", 5.0)
	set_instance_shader_parameter("noise_mult", rng.randf_range(0.2, 2.0))
	set_instance_shader_parameter("crater_mult", rng.randf_range(0.2, 2.0))
	material.set_shader_parameter("NOISE_PATTERN", base_noise_tex)
	material.set_shader_parameter("VORONOI_PATTERN", craters_tex)

func generate_gg():
	clouds.visible = false
	atmosphere.visible = true
	aurora.visible = true
	var c = mathutils.random_color(rng, true)
	set_instance_shader_parameter("color0", c)
	set_instance_shader_parameter("color1", mathutils.mutate_color(rng, c, .1, .1, .1))
	set_instance_shader_parameter("color2", mathutils.mutate_color(rng, c, .2, .2, .2))
	set_instance_shader_parameter("color3", mathutils.mutate_color(rng, c, .3, .3, .3))
	set_instance_shader_parameter("color4", mathutils.mutate_color(rng, c, .4, .4, .4))
	set_instance_shader_parameter("noise_mult", rng.randf_range(0.2, 2.0))
	set_instance_shader_parameter("crater_mult", 0.0)
	set_instance_shader_parameter("poles_mult", 0.0)
	material.set_shader_parameter("NOISE_PATTERN", stripes_tex)
	material.set_shader_parameter("VORONOI_PATTERN", craters_tex)

func load_namesfile():
	var file = FileAccess.open("res://datafiles/names.json", FileAccess.READ)
	namesfile_data = JSON.parse_string(file.get_as_text())

func load_flavorfile():
	var file = FileAccess.open("res://datafiles/flavortext.json", FileAccess.READ)
	flavorfile_data = JSON.parse_string(file.get_as_text())

func pick_seed_random(ar):
	return ar[rng.randi() % ar.size()]

func generate_text():
	var nm = pick_seed_random(namesfile_data.names)
	if rng.randf() < 0.75:
		nm += " " + pick_seed_random(namesfile_data.names)
	nm += " " + pick_seed_random(namesfile_data.numbers)
	nm += "\n[color=B3B3B3]" + String.num_int64(rng.seed, 36, true) + "[/color]"
	nm += "\n——————————"
	
	var tm = ""
	var ty = ""
	var name_color = ""

	match temp:
		TEMP.VERY_HOT: 
			name_color = "EE5622"
			tm = pick_seed_random(namesfile_data.v_hot) + " "
		TEMP.HOT: 
			var hot_names = namesfile_data.hot
			if type == PTYPE.TERRA:
				hot_names.append_array(namesfile_data.hot_terra)
			name_color = "CC2936"
			tm = pick_seed_random(hot_names) + " "
		TEMP.TEMPERATE:
			var temp_names = namesfile_data.temperate
			if type == PTYPE.TERRA:
				temp_names.append_array(namesfile_data.temperate_terra)
			name_color = "345511"
			tm = pick_seed_random(temp_names) + " "
		TEMP.COLD:
			name_color = "0E9594"
			tm = pick_seed_random(namesfile_data.cold) + " "
		TEMP.VERY_COLD:
			name_color = "4F359B"
			tm = pick_seed_random(namesfile_data.v_cold) + " "

	match type:
		PTYPE.SELENA:
			match temp:
				TEMP.VERY_HOT, TEMP.HOT, TEMP.TEMPERATE:
					ty = "selena"
				TEMP.COLD, TEMP.VERY_COLD:
					ty = "icy body"
			ty += "\n"
		PTYPE.TERRA:
			match temp:
				TEMP.VERY_HOT:
					ty = "desert world"
				TEMP.HOT, TEMP.TEMPERATE, TEMP.COLD:
					ty = "terra"
				TEMP.VERY_COLD:
					ty = "ice world"
			ty += "\n"
		PTYPE.GAS_GIANT:
			match temp:
				TEMP.VERY_HOT:
					ty = "hot jupiter"
				TEMP.HOT, TEMP.TEMPERATE:
					ty = "gas giant"
				TEMP.COLD, TEMP.VERY_COLD:
					ty = "ice giant"
			ty += "\n"

	var rd
	if !is_gas_giant:
		rd = str(round(pow(scale.x, 3.0) * 6000. )) + " km"
	else:
		rd = str(round(pow(scale.x, 5.5) * 6000. )) + " km"

	var fl = ""
	match type:
		PTYPE.GAS_GIANT:
			fl += pick_seed_random(flavorfile_data.gas_giant_1)
			if rng.randf() < 0.1:
				fl += " " + pick_seed_random(flavorfile_data.gas_giant_life_1)
		PTYPE.SELENA:
			fl += pick_seed_random(flavorfile_data.selena_1)
		PTYPE.TERRA:
			fl += pick_seed_random(flavorfile_data.terra_1)
	
	if type == PTYPE.TERRA and temp != TEMP.VERY_COLD and temp != TEMP.VERY_HOT and rng.randf() < 0.1:
		fl += " " + pick_seed_random(flavorfile_data.terra_life_1)
	
	label.text = ("[color=ffeedd]" + 
				nm +
				"[/color]\n[color=777DA7]" +
				"[color=" +
				name_color +
				"]" +
				tm +
				"[/color]"+
				ty +
				rd +
				"\n[/color][color=B3B3B3]" +
				fl +
				"[/color]")

func randomize_noise():
	base_noise.noise_type = 1 #simplex smooth
	base_noise.fractal_type = rng.randi_range(1, 3)
	base_noise.fractal_lacunarity = rng.randf_range(2., 4.)
	base_noise.frequency = rng.randf_range(0.002, 0.008)
	base_noise.seed = rng.seed
	
	craters.noise_type = 2 #cellular
	craters.cellular_jitter = 1
	craters.frequency = rng.randf_range(0.01, 0.05)
	craters.fractal_type = 0
	craters.seed = rng.seed
	
	base_noise_tex.noise = base_noise
	craters_tex.noise = craters
	stripes_tex.noise = base_noise
