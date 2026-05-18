class_name Card
extends Resource

enum Suit { HEARTS, DIAMONDS, CLUBS, SPADES }
enum Rank { TWO = 2, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING, ACE }

@export var suit: Suit
@export var rank: Rank

func get_blackjack_value() -> int:
	if rank >= Rank.TEN and rank <= Rank.KING:
		return 10
	elif rank == Rank.ACE:
		return 11 # The hand will handle dynamically adjusting 11 to 1 if we bust
	return rank

func _to_string() -> String:
	var rank_str = str(rank)
	match rank:
		Rank.JACK: rank_str = "J"
		Rank.QUEEN: rank_str = "Q"
		Rank.KING: rank_str = "K"
		Rank.ACE: rank_str = "A"
		
	var suit_str = ""
	match suit:
		Suit.HEARTS: suit_str = "♥"
		Suit.DIAMONDS: suit_str = "♦"
		Suit.CLUBS: suit_str = "♣"
		Suit.SPADES: suit_str = "♠"
		
	return rank_str + suit_str
