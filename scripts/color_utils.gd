extends Object
class_name ColorUtils

func random_color(rng: RandomNumberGenerator, normalized: bool = false):
	var r = pow(rng.randf(), 3.0)
	var g = pow(rng.randf(), 3.0)
	var b = pow(rng.randf(), 3.0)
	if normalized:
		return Vector4(r, g, b, 1.0).normalized()
	else:
		return Vector4(r, g, b, 1.0)

func random_red(rng: RandomNumberGenerator, variance: float = 2.0, brightness: float = 1.0):
	var r = rng.randf_range(0.2, 1.0) * brightness
	var g = pow(rng.randf_range(0.0, 0.5) * brightness, variance)
	var b = pow(rng.randf_range(0.0, 0.5) * brightness, variance)
	return Vector4(r, g, b, 1.0)

func random_green(rng: RandomNumberGenerator, variance: float = 2.0, brightness: float = 1.0):
	var r = pow(rng.randf_range(0.0, 0.5) * brightness, variance)
	var g = rng.randf_range(0.2, 1.0) * brightness
	var b = pow(rng.randf_range(0.0, 0.5) * brightness, variance)
	return Vector4(r, g, b, 1.0)

func random_blue(rng: RandomNumberGenerator, variance: float = 2.0, brightness: float = 1.0):
	var r = pow(rng.randf_range(0.0, 0.5) * brightness, variance)
	var g = pow(rng.randf_range(0.0, 0.5) * brightness, variance)
	var b = rng.randf_range(0.2, 1.0) * brightness
	return Vector4(r, g, b, 1.0)

func random_white(rng: RandomNumberGenerator, variance: float = 2.0, brightness: float = 1.0):
	var r = clamp(rng.randf_range(0.6, 1.0) * brightness, 0., 1.)
	var g = r# + (randf_range(0.1, 0.2) * variance)
	var b = r #+ (randf_range(0.1, 0.2) * variance)
	return Vector4(r, g, b, 1.0)

func mutate_color(rng: RandomNumberGenerator, color: Vector4, r: float, g: float, b: float):
	return Vector4(color.x + rng.randf_range(-r, r), color.y + rng.randf_range(-g, g), color.z + rng.randf_range(-b, b), 1.0)
