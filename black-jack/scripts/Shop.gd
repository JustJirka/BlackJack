extends Control

var consumables_db = [
	{"id": "XRAY", "name": "X-Ray", "cost": 3, "desc": "See the next card"},
	{"id": "SHREDDER", "name": "Shredder", "cost": 4, "desc": "Delete last drawn card"},
	{"id": "HEART_STICKER", "name": "Heart Sticker", "cost": 3, "desc": "+1 to hand score"},
	{"id": "REWIND", "name": "Rewind", "cost": 5, "desc": "Refund and reset hand"},
	{"id": "POCKETWATCH", "name": "Pocketwatch", "cost": 5, "desc": "Reset current stake"}
]

var passives_db = [
	{"id": "SAVINGS", "name": "Savings Account", "cost": 8, "desc": "+$5 cash when round is cleared"},
	{"id": "BIG_SALE", "name": "Big Sale", "cost": 10, "desc": "All cards count as half value"},
	{"id": "ALL_OR_NOTHING", "name": "All or Nothing", "cost": 12, "desc": "Going ALL IN refunds chips on loss once per blind"}
]

@onready var consumables_container = $MainLayout/ItemsContainer/ConsumablesSection/HBoxContainer
@onready var passives_container = $MainLayout/ItemsContainer/PassiveSection/HBoxContainer

func _ready():
	update_cash_display()
	$NextButton.pressed.connect(_on_next_pressed)
	
	# Clear placeholders
	for child in consumables_container.get_children():
		consumables_container.remove_child(child)
		child.queue_free()
	for child in passives_container.get_children():
		passives_container.remove_child(child)
		child.queue_free()
		
	# Populate shop with random items
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	for i in range(2): # 2 consumables in shop
		var item = consumables_db[rng.randi() % consumables_db.size()]
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(140, 150)
		btn.text = item.name + "\n$" + str(item.cost) + "\n\n" + item.desc
		btn.add_theme_font_size_override("font_size", 14)
		btn.pressed.connect(func(): _on_buy_consumable(item, btn))
		consumables_container.add_child(btn)

	for i in range(2): # 2 passives in shop
		var item = passives_db[rng.randi() % passives_db.size()]
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(140, 150)
		btn.text = item.name + "\n$" + str(item.cost) + "\n\n" + item.desc
		btn.add_theme_font_size_override("font_size", 14)
		btn.pressed.connect(func(): _on_buy_passive(item, btn))
		passives_container.add_child(btn)

func update_cash_display():
	$CashLabel.text = "Cash: $" + str(RunState.money)

func _on_buy_consumable(item, btn: Button):
	if RunState.money >= item.cost and RunState.consumables.size() < RunState.max_consumables:
		RunState.money -= item.cost
		RunState.consumables.append(item.id)
		update_cash_display()
		btn.queue_free() # Remove from shop

func _on_buy_passive(item, btn: Button):
	if RunState.money >= item.cost and not RunState.passives.has(item.id) and RunState.passives.size() < RunState.max_passives:
		RunState.money -= item.cost
		RunState.passives.append(item.id)
		update_cash_display()
		btn.queue_free() # Remove from shop

func _on_next_pressed():
	get_tree().change_scene_to_file("res://scenes/BlindSelect.tscn")
