class_name Deck
extends Node

var cards: Array[Card] = []

func _init():
	build_deck()

func build_deck():
	cards.clear()
	for suit in Card.Suit.values():
		for rank in Card.Rank.values():
			var c = Card.new()
			c.suit = suit
			c.rank = rank
			cards.append(c)

func shuffle():
	cards.shuffle()

func draw() -> Card:
	if cards.size() > 0:
		return cards.pop_back()
	return null
