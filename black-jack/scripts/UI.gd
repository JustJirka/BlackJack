extends Control

@onready var game_manager = $"../../GameManager"

@onready var dealer_score_label = $DealerScoreLabel
@onready var dealer_container = $DealerCardsContainer
@onready var player_score_label = $PlayerScoreLabel
@onready var player_container = $PlayerCardsContainer
@onready var chips_visualizer = $ChipsVisualizer
@onready var message_label = $MessageLabel
@onready var chips_label = $ChipsLabel
@onready var round_info_label = $RoundInfoLabel
@onready var bet_label = $BetLabel

@onready var hit_button = $HitButton
@onready var stand_button = $StandButton
@onready var chip_buttons = [
	$BettingChipsContainer/Chip1,
	$BettingChipsContainer/Chip5,
	$BettingChipsContainer/Chip25,
	$BettingChipsContainer/Chip100,
	$BettingChipsContainer/Chip500
]
@onready var all_in_button = $AllInButton
@onready var start_button = $StartRoundButton
@onready var debug_win_button = $DebugWinButton
@onready var consumables_container = $ConsumablesContainer

func _ready():
	game_manager.hand_updated.connect(_on_hand_updated)
	game_manager.game_over.connect(_on_game_over)
	game_manager.turn_changed.connect(_on_turn_changed)
	game_manager.chips_updated.connect(_on_chips_updated)
	game_manager.round_info_updated.connect(_on_round_info_updated)
	
	hit_button.pressed.connect(_on_hit_pressed)
	stand_button.pressed.connect(_on_stand_pressed)
	for btn in chip_buttons:
		btn.pressed.connect(func(): _on_chip_bet_pressed(btn.chip_value))
	all_in_button.pressed.connect(_on_all_in_pressed)
	start_button.pressed.connect(_on_start_pressed)
	debug_win_button.pressed.connect(_on_debug_win_pressed)
	
	chips_visualizer.update_chips(RunState.chips, game_manager.current_bet)
	_update_consumables_ui()
	_update_passives_ui()

func _update_passives_ui():
	var passives_container = $PassivesContainer
	if not passives_container:
		return
	for child in passives_container.get_children():
		child.queue_free()
		
	for i in range(RunState.passives.size()):
		var p_id = RunState.passives[i]
		var l = Label.new()
		l.text = "[ " + str(p_id).capitalize() + " ]"
		l.add_theme_font_size_override("font_size", 18)
		l.add_theme_color_override("font_color", Color(1.0, 0.5, 0.0))
		passives_container.add_child(l)

func _update_consumables_ui():
	for child in consumables_container.get_children():
		child.queue_free()
		
	for i in range(RunState.consumables.size()):
		var consumable_id = RunState.consumables[i]
		var btn = Button.new()
		btn.text = str(consumable_id).capitalize()
		btn.custom_minimum_size = Vector2(120, 40)
		btn.pressed.connect(func(): _on_consumable_pressed(i, consumable_id))
		consumables_container.add_child(btn)

func _on_consumable_pressed(index: int, id: String):
	game_manager.use_consumable(id)
	RunState.consumables.remove_at(index)
	_update_consumables_ui()

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
	
	var is_boss_blind = (RunState.current_round == 3 and RunState.current_boss_modifier == "BOSS_BLIND")
	var player_has_hidden = false
	
	# Format player
	for i in range(player_hand.cards.size()):
		var c = player_hand.cards[i]
		var card_ui = card_scene.instantiate()
		player_container.add_child(card_ui)
		
		var rng = RandomNumberGenerator.new()
		rng.seed = c.get_instance_id()
		
		var is_blind = is_boss_blind and (rng.randf() < 0.35)
		if is_blind:
			player_has_hidden = true
			
		var animate_p = is_initial_deal or (is_player_turn and i == player_hand.cards.size() - 1)
		card_ui.setup(c, is_blind, animate_p)
		
		# Scatter effect
		rng.seed = c.get_instance_id() + 1
		card_ui.position = Vector2(i * 35 - 30, i * 15)
		card_ui.rotation_degrees = rng.randf_range(-12.0, 12.0)
		
	if player_has_hidden:
		player_score_label.text = "Player (?):"
	else:
		player_score_label.text = "Player (" + str(player_hand.get_score()) + "):"
		
	# Format dealer
	var hide_dealer = game_manager.state == game_manager.GameState.BETTING or game_manager.state == game_manager.GameState.PLAYER_TURN
	
	if hide_dealer and dealer_hand.cards.size() > 0:
		dealer_score_label.text = "Dealer:"
		for i in range(dealer_hand.cards.size()):
			var c = dealer_hand.cards[i]
			var card_ui = card_scene.instantiate()
			dealer_container.add_child(card_ui)
			
			var rng = RandomNumberGenerator.new()
			rng.seed = c.get_instance_id()
			var is_blind = i > 0 or (is_boss_blind and rng.randf() < 0.35)
			
			var animate_d = is_initial_deal or (is_dealer_turn and i == dealer_hand.cards.size() - 1)
			card_ui.setup(c, is_blind, animate_d)
			
			rng.seed = c.get_instance_id() + 1
			card_ui.position = Vector2(i * 35 - 30, i * 15)
			card_ui.rotation_degrees = rng.randf_range(-12.0, 12.0)
	else:
		var dealer_has_hidden = false
		for i in range(dealer_hand.cards.size()):
			var c = dealer_hand.cards[i]
			var card_ui = card_scene.instantiate()
			dealer_container.add_child(card_ui)
			
			var rng = RandomNumberGenerator.new()
			rng.seed = c.get_instance_id()
			var is_blind = is_boss_blind and (rng.randf() < 0.35)
			if is_blind:
				dealer_has_hidden = true
				
			var animate_d = is_initial_deal or (is_dealer_turn and i == dealer_hand.cards.size() - 1)
			card_ui.setup(c, is_blind, animate_d)
			
			rng.seed = c.get_instance_id() + 1
			card_ui.position = Vector2(i * 35 - 30, i * 15)
			card_ui.rotation_degrees = rng.randf_range(-12.0, 12.0)
			
		if dealer_has_hidden:
			dealer_score_label.text = "Dealer (?):"
		else:
			dealer_score_label.text = "Dealer (" + str(dealer_hand.get_score()) + "):"

func _on_game_over(message):
	message_label.text = message
	update_buttons()

func _on_turn_changed(is_player_turn):
	update_buttons()

func _on_chips_updated(chips):
	chips_label.text = "Chips: " + str(chips)
	bet_label.text = "Bet: " + str(game_manager.current_bet)
	chips_visualizer.update_chips(chips, game_manager.current_bet)
	update_buttons()

func _on_round_info_updated(stage, round_idx, target, hands_left):
	var stage_name = "Low Stakes"
	if round_idx == 2:
		stage_name = "High Stakes"
	elif round_idx == 3:
		stage_name = "Pit Boss"
		
	round_info_label.text = "Stage " + str(stage) + " - " + stage_name + "\nTarget: " + str(target) + "\nHands Left: " + str(hands_left)

func _on_hit_pressed():
	game_manager.hit()

func _on_stand_pressed():
	game_manager.stand()

func _on_chip_bet_pressed(val):
	game_manager.place_bet(val)
	message_label.text = ""

func _on_all_in_pressed():
	if RunState.chips > 0:
		game_manager.is_all_in = true
		game_manager.place_bet(RunState.chips)
		message_label.text = ""

func _on_start_pressed():
	message_label.text = ""
	player_score_label.text = "Player:"
	dealer_score_label.text = "Dealer:"
	game_manager.start_round()
	update_buttons()

func _on_debug_win_pressed():
	RunState.chips = RunState.get_current_target() + 100
	game_manager.end_round("DEBUG WIN!")

func update_buttons():
	var state = game_manager.state
	hit_button.disabled = state != game_manager.GameState.PLAYER_TURN
	stand_button.disabled = state != game_manager.GameState.PLAYER_TURN
	
	for btn in chip_buttons:
		btn.disabled = state != game_manager.GameState.BETTING or RunState.chips < btn.chip_value
	all_in_button.disabled = state != game_manager.GameState.BETTING or RunState.chips <= 0
	start_button.disabled = state != game_manager.GameState.BETTING or game_manager.current_bet == 0
