extends Node

var chips: int = 100
var current_stage: int = 1
var current_round: int = 1 # 1: Small, 2: Big, 3: Boss
var max_hands: int = 5

var money: int = 0
var last_payout_base: int = 0
var last_payout_hands: int = 0
var last_payout_excess: int = 0

var consumables: Array = []
var max_consumables: int = 2

var passives: Array = []
var max_passives: int = 5
var all_in_protection_used: bool = false

func get_target(stage, round_idx) -> int:
	var stage_multiplier = 1.0 + (stage - 1) * 0.5
	if round_idx == 1:
		return int(150 * stage_multiplier)
	elif round_idx == 2:
		return int(250 * stage_multiplier)
	else:
		return int(400 * stage_multiplier)

func get_current_target() -> int:
	return get_target(current_stage, current_round)

func advance_round():
	current_round += 1
	if current_round > 3:
		current_round = 1
		current_stage += 1
		
	all_in_protection_used = false

func reset_run():
	chips = 100
	current_stage = 1
	current_round = 1
	money = 0
	passives.clear()
	consumables.clear()
	all_in_protection_used = false

func calculate_payout(target: int, hands_played: int):
	last_payout_base = 5
	if passives.has("SAVINGS"):
		last_payout_base += 5
	last_payout_hands = max(0, max_hands - hands_played) * 1
	var excess = chips - target
	last_payout_excess = int(excess / 50.0)
	if last_payout_excess < 0:
		last_payout_excess = 0
	
	var total = last_payout_base + last_payout_hands + last_payout_excess
	money += total
