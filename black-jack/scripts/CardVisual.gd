extends Control

@onready var anim_root = $AnimRoot
@onready var panel = $AnimRoot/Panel
@onready var top_left_label = $AnimRoot/Panel/TopLeftLabel
@onready var center_label = $AnimRoot/Panel/CenterLabel
@onready var back_rect = $AnimRoot/BackRect

func setup(card: Card, is_hidden: bool = false, animate: bool = true):
	if is_hidden:
		panel.hide()
		back_rect.show()
	else:
		panel.show()
		back_rect.hide()
		
		var rank_str = _get_rank_str(card.rank)
		var suit_str = _get_suit_str(card.suit)
		var color = _get_suit_color(card.suit)
		
		top_left_label.text = rank_str + "\n" + suit_str
		top_left_label.add_theme_color_override("font_color", color)
		
		center_label.text = suit_str
		center_label.add_theme_color_override("font_color", color)

	if animate:
		# Play dealing animation
		anim_root.position.y = -80
		anim_root.modulate.a = 0.0
		
		var tween = create_tween()
		tween.set_parallel(true)
		tween.set_trans(Tween.TRANS_BACK)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(anim_root, "position:y", 0.0, 0.4)
		tween.tween_property(anim_root, "modulate:a", 1.0, 0.4)
	else:
		anim_root.position.y = 0.0
		anim_root.modulate.a = 1.0

func _get_rank_str(rank) -> String:
	match rank:
		Card.Rank.JACK: return "J"
		Card.Rank.QUEEN: return "Q"
		Card.Rank.KING: return "K"
		Card.Rank.ACE: return "A"
		_: return str(rank)

func _get_suit_str(suit) -> String:
	match suit:
		Card.Suit.HEARTS: return "♥"
		Card.Suit.DIAMONDS: return "♦"
		Card.Suit.CLUBS: return "♣"
		Card.Suit.SPADES: return "♠"
	return ""

func _get_suit_color(suit) -> Color:
	if suit == Card.Suit.HEARTS or suit == Card.Suit.DIAMONDS:
		return Color(0.8, 0.1, 0.1) # Red
	return Color(0.1, 0.1, 0.1) # Black
