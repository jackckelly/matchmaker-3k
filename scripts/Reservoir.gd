extends Node2D

const start = Vector2(0, 0)

const row_offset_x = 5
const row_offset_y = 95
const col_offset_x = 100
const col_offset_y = 3

const cards_per_row = 5
const max_cards = 10
const duration = 8

var progress = 100
var waiting_for_card = false

onready var _sound = get_tree().get_root().get_node("Sound")

func _ready():
	pass

func add_card(card):
	card.pair_state = card.PairState.RESERVOIR
	$Cards.add_child(card)
	self.update_positions() 
	waiting_for_card = (len($Cards.get_children()) < max_cards)

func remove_card(card):
	if len($Cards.get_children()) >= max_cards:
		progress = 0
	for c in $Cards.get_children():
		if c == card:
			card.pair_state = card.PairState.UNPAIRED
			$Cards.remove_child(card)
			break
	self.update_positions()
	
func update_positions():
	var child_cards = $Cards.get_children()
	for i in range(0, len(child_cards)):
		var col = i % cards_per_row
		var row = i / cards_per_row
		# TODO: make these offsets constants / find way to reference shape of card 
		var new_x = 60 +  47 +  col * col_offset_x + row * row_offset_x
		var new_y = 15 + 79 + col * col_offset_y + row * row_offset_y
		child_cards[i].set_position(Vector2(new_x, new_y))
		

func _process(delta):
	#print(progress, waiting_for_card)
	progress = min(100, progress +  100 * delta / duration)
	$ProgressBar.value = 100 - progress
	
	if progress >= 100 and len($Cards.get_children()) <  max_cards:
		get_parent().add_card_to_reservoir()
		_sound.get_node("BoopBb").play()
		if len($Cards.get_children()) <  max_cards:
			progress = 0
		else:
			progress = 100
