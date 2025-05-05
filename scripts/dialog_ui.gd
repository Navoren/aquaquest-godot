extends Control

signal text_animation_done
signal choice_selected

const ChoiceButtonScene = preload("res://scenes/player_choice.tscn")

@onready var dialog_line = %DialogLine
@onready var speaker_name = %SpeakerName
@onready var text_blip_sound = %TextBlipSound
@onready var choice_list = %ChoiceList

const ANIMATION_SPEED : int = 30
const NO_SOUND_CHARS : Array = [".", "!", "?"]

var animate_text : bool = false
var current_visible_characters : int = 0
var current_character_details : Dictionary

func _ready():
	choice_list.hide()
	
func _process(delta):
	if animate_text:
		if dialog_line.visible_ratio < 1:
			dialog_line.visible_ratio += (1.0/ dialog_line.text.length()) * (ANIMATION_SPEED * delta)
			if dialog_line.visible_characters > current_visible_characters:
				current_visible_characters = dialog_line.visible_characters
				var last_char = dialog_line.text[current_visible_characters - 1]
				if last_char not in NO_SOUND_CHARS:
					text_blip_sound.play_sound(current_character_details)
		else:
			animate_text = false
			text_animation_done.emit()	

func change_line(character_name: Character.Name, line: String):
	current_character_details = Character.CHARACTER_DETAILS[character_name]
	speaker_name.text = Character.CHARACTER_DETAILS[character_name]["name"]
	current_visible_characters = 0
	dialog_line.text = line
	dialog_line.visible_characters = 0
	animate_text = true

func display_choices(choices: Array):
	for child in choice_list.get_children():
		child.queue_free()

	for choice in choices:
		var choice_button = ChoiceButtonScene.instantiate()
		choice_button.text = choice["text"]
		choice_button.pressed.connect(_on_choice_button_pressed.bind(choice["goto"]))
		choice_list.add_child(choice_button)
	
	choice_list.show()	

func skip_text_animation():
	dialog_line.visible_ratio = 1

func _on_choice_button_pressed(anchor: String):
	choice_selected.emit(anchor)
	choice_list.hide()
