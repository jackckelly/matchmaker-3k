extends Node2D

const PersonData = preload("res://scripts/PersonData.gd")


const sprite_array = [
	preload("res://assets/pixel_faces/00238.png"),
	preload("res://assets/pixel_faces/00365.png"),
	preload("res://assets/pixel_faces/00995.png"),
]

const name_array = [
	"Alice",
	"Bob"
]

#var past_names = []
#var current_names = []
#var remaining_names = []
#
#var past_faces = []
#var current_faces = []
#var remaining_faces = []


var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	
	
	# disabling the dynamic loading while I rewrite the class
	
#	# faces
#	var path = "res://assets/pixel_faces/"
#	var dir = Directory.new()
#	dir.open(path)
#	dir.list_dir_begin()
#	var file_name = dir.get_next()
#	while file_name != "":
#		if file_name.ends_with('.png'):
#			var texture = load(path + file_name)
#			sprite_array.append(texture)
#		file_name = dir.get_next()
#	dir.list_dir_end()
#
#	# names
#	path  = "res://assets/names.txt"
#	var f = File.new()
#	f.open(path, File.READ)
#	while not f.eof_reached(): # iterate through all lines until the end of file is reached
#		var line = f.get_line()
#		name_array.append(line)
#	f.close()
#	return

func _new_stat():
	return rng.randi_range(0, 1) * 2 - 1

func new_person_data():
	var stats ={
		'left': [_new_stat(), _new_stat()],
		'right': [_new_stat(), _new_stat()],
	}

	var icon_ids = [0, 0, 0, 0]
	for i in range(0, len(icon_ids)):
		var cand = rng.randi_range(1, 41)
		while icon_ids.has(cand):
			cand = rng.randi_range(1, 41)
		icon_ids[i] = cand 
	
	var num_likes = rng.randi_range(0, 4)
	var like_mask = [0, 0, 0, 0]
	for i in range(0, len(like_mask)):
		if i >= num_likes:
			like_mask[i] = 0
		else:
			like_mask[i] = 1
	
	var face_id = sprite_array[rng.randi_range(0, len(sprite_array) - 1)]
	var first_name = name_array[rng.randi_range(0, len(name_array) - 1)]
	
	var gender = 'male'
	var age = rng.randi_range(18, 49)
	
	var bio = 'Kind of a mess but you know what that\'s fine'
	
	return PersonData.new(
		stats,
		icon_ids,
		like_mask,
		face_id,
		first_name,
		gender,
		age,
		bio
	)

func new_sprite_texture():
	return sprite_array[rng.randi_range(0, len(sprite_array) - 1)]

func new_name():
	return name_array[rng.randi_range(0, len(name_array) - 1)]
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass