extends Node

var num_hills = 2
var slice = 10
var hill_range = 100\

var screensize = get_viewport().get_visible_rect().size
var terrain = Array()
var texture : Texture

func _ready():
	randomize()

	terrain = Array()
	var start_y = screensize.y * 3/4 + (-hill_range + randi() % hill_range*2)
	terrain.append(Vector2(0, start_y))
	add_hills()

	# Use preprocess instead of preload to load the texture
	texture = load("res://Sprites/grass.png")

func _process(delta):
	if terrain[-1].x < $car1.position.x + screensize.x / 2:
		add_hills()

	if terrain[0].x > $car1.position.x - screensize.x / 2:
		add_hills()

func add_hills(backside=false):
	var hill_width = screensize.x / num_hills
	var hill_slices = hill_width / slice
	var start = terrain[-1] if not backside else terrain[0]
	var poly = PackedVector2Array()
	for i in range(num_hills):
		var height = randi() % hill_range
		start.y -= height
		for j in range(0, hill_slices):
			var hill_point = Vector2()
			hill_point.x = start.x + j * slice + hill_width * i
			hill_point.y = start.y + height * cos(2 * PI / hill_slices * j)
			terrain.append(hill_point) if not backside else terrain.insert(0, hill_point)
			poly.append(hill_point)
		start.y += height
	
	var shape = CollisionPolygon2D.new()
	var ground = Polygon2D.new()
	$StaticBody2D.add_child(shape)
	poly.append(Vector2(terrain[-1].x, screensize.y))
	poly.append(Vector2(terrain[0].x, screensize.y)) if backside else poly.append(Vector2(terrain[-1].x, screensize.y))
	shape.polygon = poly
	ground.polygon = poly
	ground.texture = texture
	add_child(ground)
