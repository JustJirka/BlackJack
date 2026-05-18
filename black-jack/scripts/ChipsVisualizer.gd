extends Control

var chip_values = [
	{ "value": 500, "color": Color(0.5, 0.1, 0.5), "border": Color(1, 1, 1) }, # Purple
	{ "value": 100, "color": Color(0.1, 0.1, 0.1), "border": Color(1, 1, 1) }, # Black
	{ "value": 25, "color": Color(0.1, 0.6, 0.2), "border": Color(1, 1, 1) },  # Green
	{ "value": 5, "color": Color(0.8, 0.1, 0.1), "border": Color(1, 1, 1) },   # Red
	{ "value": 1, "color": Color(0.9, 0.9, 0.9), "border": Color(0.2, 0.2, 0.2) } # White
]

var total_chips = 0
var bet_chips = 0

func update_chips(total: int, bet: int):
	total_chips = total
	bet_chips = bet
	queue_redraw()

func _draw():
	# Total chips at bottom-left corner
	_draw_chip_stacks(total_chips, Vector2(100, 600))
	
	# Current bet chips on the table near the player's cards
	if bet_chips > 0:
		_draw_chip_stacks(bet_chips, Vector2(400, 450))

func _draw_chip_stacks(amount: int, start_pos: Vector2):
	var remaining = amount
	var stack_offset_x = 0
	
	for chip_def in chip_values:
		var val = chip_def["value"]
		var count = remaining / val
		remaining = remaining % val
		
		if count > 0:
			var visual_count = min(count, 40) # Cap visual height so it doesn't fly off screen
			var base_pos = start_pos + Vector2(stack_offset_x, 0)
			
			for i in range(visual_count):
				# Slight vertical stacking overlap
				var chip_pos = base_pos - Vector2(0, i * 4)
				_draw_single_chip(chip_pos, chip_def)
				
			stack_offset_x += 45 # Horizontal spacing for the next stack of different value

func _draw_single_chip(pos: Vector2, def: Dictionary):
	var color = def["color"]
	var border = def["border"]
	
	# 3D Thickness / shadow edge
	draw_circle(pos, 20, color.darkened(0.4))
	
	var top_pos = pos - Vector2(0, 3)
	
	# Main base color
	draw_circle(top_pos, 20, color)
	
	# Outer striped ring effect
	draw_circle(top_pos, 16, border)
	
	# Inner colored core
	draw_circle(top_pos, 12, color)
	
	# Value text (Optional but cool if it fits, though might get messy. Let's just do a tiny center dot for realism)
	draw_circle(top_pos, 6, border)
