extends Control

func _ready():
	$SummaryLabel.text = "ROUND CLEARED!\n\n" + \
		"Base Reward: $" + str(RunState.last_payout_base) + "\n" + \
		"Hands Left: $" + str(RunState.last_payout_hands) + "\n" + \
		"Extra Chips: $" + str(RunState.last_payout_excess) + "\n" + \
		"----------------\n" + \
		"Total Cash: $" + str(RunState.money)
	
	$NextButton.pressed.connect(_on_next_pressed)

func _on_next_pressed():
	get_tree().change_scene_to_file("res://scenes/Shop.tscn")
