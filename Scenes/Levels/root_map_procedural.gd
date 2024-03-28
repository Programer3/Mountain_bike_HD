extends Node

# Define initial variables for terrain generation
var num_hills = 2  # Number of hills to generate per screen width
var slice = 10  # Width of each slice of the hill
var hill_range = 100  # Maximum height variation for hills
var screensize  # To store the size of the game screen
var terrain = Array()  # To store the points of the terrain
var texture = preload("res://Sprites/Terrain/DirtBG.png")  # Load the texture for the ground
@onready var static_body_2d = $StaticBody2D  # Reference to the StaticBody2D node for collision
@onready var line_2d = $Line2D  # Reference to the Line2D node for drawing the terrain
@onready var car_1 = $car1  # Reference to the car node

func _ready():
	randomize()  # Initialize the random number generator
	screensize = get_viewport().get_visible_rect().size # Get the size of the game screen
	# Calculate the starting Y position of the terrain
	var start_y = screensize.y * 3/4 + (-hill_range + randi() % hill_range*2)
	terrain.append(Vector2(0, start_y))  # Initialize the terrain with the starting point
	add_hills(true)  # Initially generate hills to the right of the start point
func _process(delta):
	# Calculate the lookahead distance based on the car's velocity or a minimum value
	var lookahead = screensize.x / 2 + max(car_1.linear_velocity.x, 100)
	# Add hills to the right if the car is nearing the current rightmost hill
	if terrain[-1].x < car_1.position.x + lookahead:
		add_hills(true)
	# Add hills to the left if the car is nearing the current leftmost hill
	if terrain[0].x > car_1.position.x - lookahead:
		add_hills(false)

func add_hills(to_right: bool):
	var hill_width = screensize.x / num_hills  # Calculate the width of each hill
	var hill_slices = hill_width / slice  # Calculate the number of slices per hill
	var start_index = -1 if to_right else 0  # Determine the starting index based on direction
	var start = terrain[start_index]  # Get the starting point for hill generation
	var poly = PackedVector2Array()  # Initialize an array to store the points for collision shapes
	for i in range(num_hills):
		var height = (randi() % hill_range) / 1.2 # Randomly determine the height of the hill
		start.y -= height  # Adjust the starting height for the hill
		for j in range(0, hill_slices):
			# Calculate the x and y positions of each point on the hill
			var x_offset = j * slice + hill_width * i if to_right else -j * slice - hill_width * i
			var hill_point = Vector2(start.x + x_offset, start.y + height * cos(2 * PI / hill_slices * j))
			# Add the point to the Line2D and terrain array
			if to_right:
				line_2d.add_point(hill_point)
				terrain.append(hill_point)
			else:
				line_2d.add_point(hill_point, 0)
				terrain.insert(0, hill_point)
			poly.append(hill_point)  # Add the point to the polygon array
		start.y += height  # Reset the starting height for the next hill
	# Generate collision and visual representation for the newly created hills
	if to_right:
		var shape = CollisionPolygon2D.new()
		var ground = Polygon2D.new()
		static_body_2d.add_child(shape)
		# Ensure the polygon closes by adding points at the bottom
		poly.append(Vector2(terrain[-1].x, screensize.y * 2))
		poly.append(Vector2(start.x, screensize.y * 2))
		shape.polygon = poly
		ground.polygon = poly
		# Apply the texture to the ground
		ground.texture = texture
		ground.texture_scale = Vector2(1, 1)
		ground.texture_offset = Vector2(0, 0)
		ground.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
		add_child(ground)
	if not to_right:
		var shape = CollisionPolygon2D.new()
		var ground = Polygon2D.new()
		# Reverse the polygon points for leftward generation
		poly.reverse()
		static_body_2d.add_child(shape)
		# Ensure the polygon closes by adding points at the bottom
		poly.append(Vector2(terrain[0].x, screensize.y * 2))
		poly.append(Vector2(start.x, screensize.y * 2))
		shape.polygon = poly
		ground.polygon = poly
		# Apply the texture to the ground
		ground.texture = texture
		ground.texture_scale = Vector2(1, 1)
		ground.texture_offset = Vector2(0, 0)
		ground.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
		add_child(ground)
