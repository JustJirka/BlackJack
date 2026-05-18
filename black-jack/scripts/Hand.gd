class_name Hand
extends Node

var cards: Array[Card] = []
var score_modifier: int = 0

func add_card(card: Card):
	cards.append(card)

func clear():
	cards.clear()
	score_modifier = 0

# Calculates the best score (closest to 21 without busting)
func get_score() -> int:
	var score = 0
	var aces = 0
	
	var big_sale = RunState.passives.has("BIG_SALE")
	var is_boss_red = (RunState.current_round == 3 and RunState.current_boss_modifier == "BOSS_RED")
	
	for card in cards:
		var val = card.get_blackjack_value()
		if big_sale:
			val = int(val / 2.0)
		if is_boss_red and (card.suit == Card.Suit.HEARTS or card.suit == Card.Suit.DIAMONDS):
			val *= 2
		score += val
		if card.rank == Card.Rank.ACE:
			aces += 1
			
	while score > 21 and aces > 0:
		if big_sale:
			score -= 5
		else:
			score -= 10
		aces -= 1
		
	return score + score_modifier

func is_busted() -> bool:
	return get_score() > 21

func is_blackjack() -> bool:
	return cards.size() == 2 and get_score() == 21
