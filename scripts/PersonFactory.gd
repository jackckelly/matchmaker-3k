extends Node2D

const PersonData = preload("res://scripts/PersonData.gd")
const PersonConstants = preload("res://scripts/PersonConstants.gd")

var male_sprite_array = []
var female_sprite_array = []

var remaining_male_sprites = []
var remaining_female_sprites = []

const male_name_array = PersonConstants.male_names
const female_name_array =  PersonConstants.female_names

#var past_names = []
#var current_names = []
#var remaining_names = []

#var past_faces = []
#var current_faces = []
#var remaining_faces = []


var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	for face_id in range(1, PersonConstants.num_male_faces + 1):
		var path = "res://assets/faces_v4/men/%s.png" % face_id
		male_sprite_array.append(load(path))
	
	for face_id in range(1, PersonConstants.num_female_faces + 1):
		var path = "res://assets/faces_v4/women/%s.png" % face_id
		female_sprite_array.append(load(path))
	
	randomize()
	remaining_male_sprites = male_sprite_array.duplicate()
	remaining_male_sprites.shuffle()
	remaining_female_sprites = female_sprite_array.duplicate()
	remaining_female_sprites.shuffle()

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
		var cand = rng.randi_range(0, len(PersonConstants.icon_map) - 1)
		while icon_ids.has(cand):
			cand = rng.randi_range(0, len(PersonConstants.icon_map) - 1)
		icon_ids[i] = cand 
	
	var num_likes = rng.randi_range(0, 4)
	var like_mask = [0, 0, 0, 0]
	for i in range(0, len(like_mask)):
		if i >= num_likes:
			like_mask[i] = 0
		else:
			like_mask[i] = 1
	var gender = 'male' if rng.randi_range(0, 1) == 0 else 'female'
	var face_id = null
	var first_name = null
	match gender:
		'male':
			if len(remaining_male_sprites) <= 0:
				randomize()
				remaining_male_sprites = male_sprite_array.duplicate()
				remaining_male_sprites.shuffle()
			face_id = remaining_male_sprites.pop_front()
			first_name = male_name_array[rng.randi_range(0, len(male_name_array) - 1)]
		'female':
			if len(remaining_female_sprites) <= 0:
				randomize()
				remaining_female_sprites = female_sprite_array.duplicate()
				remaining_female_sprites.shuffle()
			face_id = remaining_female_sprites.pop_front()
			first_name = female_name_array[rng.randi_range(0, len(female_name_array) - 1)]
	
	var bio = PersonConstants.bios[rng.randi_range(0, len(PersonConstants.bios) - 1)]

	var age = rng.randi_range(21, 44)
	var rate = 0.5 + rng.randf_range(0, 1)

	return PersonData.new(
		stats,
		icon_ids,
		like_mask,
		face_id,
		first_name,
		gender,
		age,
		bio,
		rate
	)

#func new_sprite_texture():
#	return sprite_array[rng.randi_range(0, len(sprite_array) - 1)]

#func new_name():
#	return name_array[rng.randi_range(0, len(name_array) - 1)]
