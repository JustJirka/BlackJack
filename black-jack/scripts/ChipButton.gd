extends Button

@export var chip_value: int = 5
@export var base_color: Color = Color(0.8, 0.1, 0.1)
@export var border_color: Color = Color(1, 1, 1)

func _ready():
	flat = true
	custom_minimum_size = Vector2(60, 60)
	text = ""

func _draw():
	var center = size / 2.0
	var radius = min(size.x, size.y) / 2.0 - 2 # Leave margin for bounce
	
	var shadow_pos = center + Vector2(0, 4)
	var top_pos = center
	
	var render_base = base_color
	var render_border = border_color
	
	if disabled:
		render_base = render_base.darkened(0.6)
		render_border = render_border.darkened(0.6)
		shadow_pos = center + Vector2(0, 1)
		top_pos = center + Vector2(0, 1)
	elif button_pressed:
		shadow_pos = center + Vector2(0, 1)
		top_pos = center + Vector2(0, 1)
	elif is_hovered():
		shadow_pos = center + Vector2(0, 5)
		top_pos = center - Vector2(0, 1)
		
	# Draw thickness edge
	draw_circle(shadow_pos, radius, render_base.darkened(0.4))
	
	# Draw top face
	draw_circle(top_pos, radius, render_base)
	draw_circle(top_pos, radius * 0.8, render_border)
	draw_circle(top_pos, radius * 0.6, render_base)
	
	# Draw Value Text
	var font = get_theme_default_font()
	var f_size = 18
	var str_val = str(chip_value)
	var text_size = font.get_string_size(str_val, HORIZONTAL_ALIGNMENT_CENTER, -1, f_size)
	var text_pos = top_pos + Vector2(-text_size.x/2.0, text_size.y/3.0) 
	draw_string(font, text_pos, str_val, HORIZONTAL_ALIGNMENT_LEFT, -1, f_size, render_border)

func _process(_delta):
	queue_redraw() # Ensures the hover/pressed visual updates dynamically
