extends Control

@onready var game_manager = $"../../GameManager"

@onready var dealer_label = $DealerCardsLabel
@onready var player_label = $PlayerCardsLabel
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
	# Format player cards
	var p_str = "Player (" + str(player_hand.get_score()) + "): "
	for c in player_hand.cards:
		p_str += c._to_string() + " "
	player_label.text = p_str
	
	# Format dealer cards
	var d_str = "Dealer: "
	if game_manager.state == game_manager.GameState.PLAYER_TURN:
		# Hide second card
		d_str += dealer_hand.cards[0]._to_string() + " ??"
	else:
		d_str = "Dealer (" + str(dealer_hand.get_score()) + "): "
		for c in dealer_hand.cards:
			d_str += c._to_string() + " "
	dealer_label.text = d_str

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
	player_label.text = "Player: "
	dealer_label.text = "Dealer: "
	game_manager.start_round()
	update_buttons()

func update_buttons():
	var state = game_manager.state
	hit_button.disabled = state != game_manager.GameState.PLAYER_TURN
	stand_button.disabled = state != game_manager.GameState.PLAYER_TURN
	
	bet_button.disabled = state != game_manager.GameState.BETTING or game_manager.chips < 10
	start_button.disabled = state != game_manager.GameState.BETTING or game_manager.current_bet == 0
