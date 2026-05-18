extends Control

@onready var small_btn = $BlindsContainer/SmallBlind/SelectButton
@onready var big_btn = $BlindsContainer/BigBlind/SelectButton
@onready var boss_btn = $BlindsContainer/BossBlind/SelectButton

func _ready():
	$StageLabel.text = "STAGE " + str(RunState.current_stage)
	
	var small_target = RunState.get_target(RunState.current_stage, 1)
	var big_target = RunState.get_target(RunState.current_stage, 2)
	var boss_target = RunState.get_target(RunState.current_stage, 3)
	
	var boss_data = RunState.get_boss_data()
	
	$BlindsContainer/SmallBlind/TargetLabel.text = "Target:\n" + str(small_target)
	$BlindsContainer/BigBlind/TargetLabel.text = "Target:\n" + str(big_target)
	$BlindsContainer/BossBlind/TargetLabel.text = "Target:\n" + str(boss_target)
	
	if RunState.current_round <= 3:
		$BlindsContainer/BossBlind/TitleLabel.text = "Pit Boss:\n" + boss_data["name"]
		$BlindsContainer/BossBlind/TitleLabel.add_theme_font_size_override("font_size", 20)
	
	small_btn.disabled = RunState.current_round != 1
	big_btn.disabled = RunState.current_round != 2
	boss_btn.disabled = RunState.current_round != 3
	
	if RunState.current_round > 1:
		$BlindsContainer/SmallBlind.modulate = Color(0.5, 0.5, 0.5)
		$BlindsContainer/SmallBlind/TitleLabel.text = "[DEFEATED]"
	if RunState.current_round > 2:
		$BlindsContainer/BigBlind.modulate = Color(0.5, 0.5, 0.5)
		$BlindsContainer/BigBlind/TitleLabel.text = "[DEFEATED]"
		
	small_btn.pressed.connect(_on_select_pressed)
	big_btn.pressed.connect(_on_select_pressed)
	boss_btn.pressed.connect(_on_select_pressed)

func _on_select_pressed():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
