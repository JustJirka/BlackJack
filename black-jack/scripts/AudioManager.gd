extends Node

# Audio players for music
var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer
var ui_player: AudioStreamPlayer

# Audio streams
var background_music: AudioStream
var chip_clink_sound: AudioStream
var card_deal_sound: AudioStream
var card_flip_sound: AudioStream
var win_sound: AudioStream
var loss_sound: AudioStream
var bust_sound: AudioStream
var blackjack_sound: AudioStream

# Audio bus for volume control
var master_bus_index: int = 0

func _ready():
	# Create audio players
	music_player = AudioStreamPlayer.new()
	sfx_player = AudioStreamPlayer.new()
	ui_player = AudioStreamPlayer.new()
	
	# Setup music player
	music_player.bus = "Master"  # Default to Master if Music bus doesn't exist
	music_player.volume_db = -5
	add_child(music_player)
	
	# Setup SFX player
	sfx_player.bus = "Master"
	sfx_player.volume_db = 0
	add_child(sfx_player)
	
	# Setup UI player
	ui_player.bus = "Master"
	ui_player.volume_db = -3
	add_child(ui_player)
	
	# Load audio files
	_load_audio_files()

func _load_audio_files():
	"""Load audio files from the audio directory"""
	# Try to load audio files, gracefully handle missing files
	background_music = _load_audio("res://audio/podkres.mp3")
	chip_clink_sound = _load_audio("res://audio/oxidvideos-placing-poker-chips-522515.mp3")
	card_deal_sound = _load_audio("res://audio/oxidvideos-placing-playing-card-522514.mp3")
	card_flip_sound = _load_audio("res://audio/oxidvideos-taking-playing-card-2-522516.mp3")
	win_sound = _load_audio("res://audio/puyopuyomegafan1234-winner-game-sound-404167.mp3")
	loss_sound = _load_audio("res://audio/tuomas_data-game-over-39-199830.mp3")
	bust_sound = _load_audio("res://audio/tuomas_data-game-over-39-199830.mp3")
	blackjack_sound = _load_audio("res://audio/universfield-video-game-bonus-323603.mp3")

func _load_audio(path: String) -> AudioStream:
	"""Safely load an audio file"""
	if ResourceLoader.exists(path):
		return load(path)
	else:
		print("Warning: Audio file not found: " + path)
		return null

# Music functions
func play_background_music():
	if background_music and not music_player.playing:
		music_player.stream = background_music
		music_player.play()

func stop_background_music():
	music_player.stop()

# Sound effect functions
func play_chip_clink():
	"""Play sound when placing a bet with chips"""
	if chip_clink_sound:
		sfx_player.stream = chip_clink_sound
		sfx_player.pitch_scale = randf_range(0.9, 1.1)
		sfx_player.play()

func play_card_deal():
	"""Play sound when dealing a card"""
	if card_deal_sound:
		sfx_player.stream = card_deal_sound
		sfx_player.pitch_scale = 1.0
		sfx_player.play()

func play_card_flip():
	"""Play sound when revealing a card"""
	if card_flip_sound:
		sfx_player.stream = card_flip_sound
		sfx_player.pitch_scale = 1.0
		sfx_player.play()

func play_win_sound():
	"""Play sound when player wins a round"""
	if win_sound:
		sfx_player.stream = win_sound
		sfx_player.pitch_scale = 1.0
		sfx_player.play()

func play_loss_sound():
	"""Play sound when player loses a round"""
	if loss_sound:
		sfx_player.stream = loss_sound
		sfx_player.pitch_scale = 1.0
		sfx_player.play()

func play_ui_click():
	"""Play sound for UI interactions"""
	if chip_clink_sound:  # Reuse chip clink for UI clicks
		ui_player.stream = chip_clink_sound
		ui_player.pitch_scale = 1.2
		ui_player.play()

func play_blackjack_sound():
	"""Play special sound for blackjack"""
	if blackjack_sound:
		sfx_player.stream = blackjack_sound
		sfx_player.pitch_scale = 1.0
		sfx_player.play()

func play_bust_sound():
	"""Play sound when busting"""
	if bust_sound:
		sfx_player.stream = bust_sound
		sfx_player.pitch_scale = 0.95
		sfx_player.play()

# Volume control
func set_master_volume(db: float):
	AudioServer.set_bus_mute(0, false)
	AudioServer.set_bus_volume_db(0, db)

func set_music_volume(db: float):
	var music_bus = AudioServer.get_bus_index("Music")
	if music_bus != -1:
		AudioServer.set_bus_volume_db(music_bus, db)

func set_sfx_volume(db: float):
	var sfx_bus = AudioServer.get_bus_index("SFX")
	if sfx_bus != -1:
		AudioServer.set_bus_volume_db(sfx_bus, db)

# Cleanup
func _exit_tree():
	music_player.queue_free()
	sfx_player.queue_free()
	ui_player.queue_free()
