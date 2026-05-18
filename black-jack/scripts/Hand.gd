class_name Hand
extends Node

var cards: Array[Card] = []

func add_card(card: Card):
	cards.append(card)

func clear():
	cards.clear()

# Calculates the best score (closest to 21 without busting)
func get_score() -> int:
	var score = 0
	var aces = 0
	
	for card in cards:
		var val = card.get_blackjack_value()
		score += val
		if card.rank == Card.Rank.ACE:
			aces += 1
			
	while score > 21 and aces > 0:
		score -= 10
		aces -= 1
		
	return score

func is_busted() -> bool:
	return get_score() > 21

func is_blackjack() -> bool:
	return cards.size() == 2 and get_score() == 21
