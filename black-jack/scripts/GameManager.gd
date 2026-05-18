extends Node

signal game_started
signal turn_changed(is_player_turn)
signal hand_updated(player_hand, dealer_hand)
signal game_over(result_message)
signal chips_updated(amount)
signal round_info_updated(stage, round_idx, target, hands_left)

var deck: Deck
var player_hand: Hand
var dealer_hand: Hand

var current_bet: int = 0
var hands_played: int = 0

enum GameState { BETTING, PLAYER_TURN, DEALER_TURN, GAME_OVER }
var state: GameState = GameState.BETTING

func _ready():
	deck = Deck.new()
	player_hand = Hand.new()
	dealer_hand = Hand.new()
	
	add_child(deck)
	add_child(player_hand)
	add_child(dealer_hand)
	
	# Initial UI update
	call_deferred("emit_initial_state")

func emit_initial_state():
	chips_updated.emit(RunState.chips)
	round_info_updated.emit(RunState.current_stage, RunState.current_round, RunState.get_current_target(), RunState.max_hands - hands_played)
	turn_changed.emit(true) # Just to trigger initial UI state

func place_bet(amount: int):
	if state == GameState.BETTING and RunState.chips >= amount:
		RunState.chips -= amount
		current_bet += amount
		chips_updated.emit(RunState.chips)

func start_round():
	if state == GameState.BETTING and current_bet > 0:
		deck.build_deck()
		deck.shuffle()
		player_hand.clear()
		dealer_hand.clear()
		
		# Deal initial cards
		player_hand.add_card(deck.draw())
		dealer_hand.add_card(deck.draw())
		player_hand.add_card(deck.draw())
		dealer_hand.add_card(deck.draw()) # Second dealer card usually hidden
		
		hand_updated.emit(player_hand, dealer_hand)
		
		if player_hand.is_blackjack():
			end_round("Player Blackjack!")
		else:
			state = GameState.PLAYER_TURN
			turn_changed.emit(true)

func hit():
	if state == GameState.PLAYER_TURN:
		player_hand.add_card(deck.draw())
		hand_updated.emit(player_hand, dealer_hand)
		
		if player_hand.is_busted():
			end_round("Player Busted! Dealer Wins.")

func stand():
	if state == GameState.PLAYER_TURN:
		state = GameState.DEALER_TURN
		turn_changed.emit(false)
		hand_updated.emit(player_hand, dealer_hand) # Reveal dealer card
		
		play_dealer_turn()

func play_dealer_turn():
	# Simple async for a short delay between dealer draws
	while dealer_hand.get_score() < 17:
		await get_tree().create_timer(1.0).timeout
		dealer_hand.add_card(deck.draw())
		hand_updated.emit(player_hand, dealer_hand)
		
		if dealer_hand.is_busted():
			break
			
	await get_tree().create_timer(1.0).timeout
	determine_winner()

func determine_winner():
	var p_score = player_hand.get_score()
	var d_score = dealer_hand.get_score()
	
	if dealer_hand.is_busted():
		end_round("Dealer Busted! Player Wins.")
	elif p_score > d_score:
		end_round("Player Wins!")
	elif d_score > p_score:
		end_round("Dealer Wins.")
	else:
		end_round("Push! (Tie)")

func end_round(message: String):
	state = GameState.GAME_OVER
	
	if "Player Wins" in message or "Blackjack" in message:
		if "Blackjack" in message:
			RunState.chips += int(current_bet * 2.5) # 3:2 payout
		else:
			RunState.chips += current_bet * 2
	elif "Push" in message:
		RunState.chips += current_bet
		
	current_bet = 0
	hands_played += 1
	
	var round_cleared = false
	var round_failed = false
	
	if RunState.chips >= RunState.get_current_target():
		message += "\nRound Cleared!"
		RunState.advance_round()
		round_cleared = true
	elif hands_played >= RunState.max_hands:
		message += "\nGame Over! Failed to reach target."
		round_failed = true
	elif RunState.chips <= 0:
		message += "\nGame Over! Bankrupt."
		round_failed = true
		
	if round_failed:
		RunState.reset_run()
		
	chips_updated.emit(RunState.chips)
	round_info_updated.emit(RunState.current_stage, RunState.current_round, RunState.get_current_target(), RunState.max_hands - hands_played)
	game_over.emit(message)
	
	if round_cleared or round_failed:
		await get_tree().create_timer(3.0).timeout
		if round_failed:
			get_tree().change_scene_to_file("res://scenes/TitleScreen.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/BlindSelect.tscn")
		return
	
	# Reset to betting state
	state = GameState.BETTING
	turn_changed.emit(true) # To update buttons back to bet mode
