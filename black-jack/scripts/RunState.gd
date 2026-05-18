extends Node

var chips: int = 100
var current_stage: int = 1
var current_round: int = 1 # 1: Small, 2: Big, 3: Boss
var max_hands: int = 5

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

func reset_run():
	chips = 100
	current_stage = 1
	current_round = 1
