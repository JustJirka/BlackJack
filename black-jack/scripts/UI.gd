extends Control

@onready var game_manager = $"../../GameManager"

@onready var dealer_score_label = $DealerScoreLabel
@onready var dealer_container = $DealerCardsContainer
@onready var player_score_label = $PlayerScoreLabel
@onready var player_container = $PlayerCardsContainer
@onready var message_label = $MessageLabel
@onready var chips_label = $ChipsLabel
@onready var bet_label = $BetLabel

@onready var hit_button = $HitButton
@onready var stand_button = $StandButton
@onready var bet_button = $Bet10Button
@onready var start_button = $StartRoundButton

func _ready():
	game_manager.hand_updated.connect(_on_hand_updated)
	game_manager.game_over.connect(_on_game_over)
	game_manager.turn_changed.connect(_on_turn_changed)
	game_manager.chips_updated.connect(_on_chips_updated)
	
	hit_button.pressed.connect(_on_hit_pressed)
	stand_button.pressed.connect(_on_stand_pressed)
	bet_button.pressed.connect(_on_bet_pressed)
	start_button.pressed.connect(_on_start_pressed)

func _on_hand_updated(player_hand, dealer_hand):
	var card_scene = preload("res://scenes/CardVisual.tscn")
	
	# Clear containers
	for child in player_container.get_children():
		child.queue_free()
	for child in dealer_container.get_children():
		child.queue_free()
		
	var is_initial_deal = game_manager.state == game_manager.GameState.BETTING
	var is_player_turn = game_manager.state == game_manager.GameState.PLAYER_TURN
	var is_dealer_turn = game_manager.state == game_manager.GameState.DEALER_TURN
	
	# Format player
	player_score_label.text = "Player (" + str(player_hand.get_score()) + "):"
	for i in range(player_hand.cards.size()):
		var c = player_hand.cards[i]
		var card_ui = card_scene.instantiate()
		player_container.add_child(card_ui)
		
		var animate_p = is_initial_deal or (is_player_turn and i == player_hand.cards.size() - 1)
		card_ui.setup(c, false, animate_p)
		
		# Scatter effect
		var rng = RandomNumberGenerator.new()
		rng.seed = c.get_instance_id()
		card_ui.position = Vector2(i * 35 - 30, i * 15)
		card_ui.rotation_degrees = rng.randf_range(-12.0, 12.0)
		
	# Format dealer
	var hide_dealer = game_manager.state == game_manager.GameState.BETTING or game_manager.state == game_manager.GameState.PLAYER_TURN
	
	if hide_dealer and dealer_hand.cards.size() > 0:
		dealer_score_label.text = "Dealer:"
		for i in range(dealer_hand.cards.size()):
			var c = dealer_hand.cards[i]
			var card_ui = card_scene.instantiate()
			dealer_container.add_child(card_ui)
			
			var animate_d = is_initial_deal or (is_dealer_turn and i == dealer_hand.cards.size() - 1)
			card_ui.setup(c, i > 0, animate_d)
			
			var rng = RandomNumberGenerator.new()
			rng.seed = c.get_instance_id()
			card_ui.position = Vector2(i * 35 - 30, i * 15)
			card_ui.rotation_degrees = rng.randf_range(-12.0, 12.0)
	else:
		dealer_score_label.text = "Dealer (" + str(dealer_hand.get_score()) + "):"
		for i in range(dealer_hand.cards.size()):
			var c = dealer_hand.cards[i]
			var card_ui = card_scene.instantiate()
			dealer_container.add_child(card_ui)
			
			var animate_d = is_initial_deal or (is_dealer_turn and i == dealer_hand.cards.size() - 1)
			card_ui.setup(c, false, animate_d)
			
			var rng = RandomNumberGenerator.new()
			rng.seed = c.get_instance_id()
			card_ui.position = Vector2(i * 35 - 30, i * 15)
			card_ui.rotation_degrees = rng.randf_range(-12.0, 12.0)

func _on_game_over(message):
	message_label.text = message
	update_buttons()

func _on_turn_changed(is_player_turn):
	update_buttons()

func _on_chips_updated(chips):
	chips_label.text = "Chips: " + str(chips)
	bet_label.text = "Bet: " + str(game_manager.current_bet)
	update_buttons()

func _on_hit_pressed():
	game_manager.hit()

func _on_stand_pressed():
	game_manager.stand()

func _on_bet_pressed():
	game_manager.place_bet(10)
	message_label.text = ""

func _on_start_pressed():
	message_label.text = ""
	player_score_label.text = "Player:"
	dealer_score_label.text = "Dealer:"
	game_manager.start_round()
	update_buttons()

func update_buttons():
	var state = game_manager.state
	hit_button.disabled = state != game_manager.GameState.PLAYER_TURN
	stand_button.disabled = state != game_manager.GameState.PLAYER_TURN
	
	bet_button.disabled = state != game_manager.GameState.BETTING or game_manager.chips < 10
	start_button.disabled = state != game_manager.GameState.BETTING or game_manager.current_bet == 0
