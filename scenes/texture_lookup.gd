class_name TextureLookup
extends Control

signal image_changed(channel: channelselect)
signal image_channel_change(image: channelselect, channel: int)

enum channelselect {RED,GREEN,BLUE,ALPHA}

@export var Channel: channelselect

@onready var texture_rect: TextureRect = $PanelContainer/VBox/TextureRect
@onready var file_dialog: FileDialog = $FileDialog
@onready var label: Label = $PanelContainer/VBox/HBoxContainer/Label
@onready var channel_select: OptionButton = $PanelContainer/VBox/HBoxContainer/ChannelSelect
@onready var panel_container: PanelContainer = $PanelContainer

var channeltouse: int = 0 #0=Red, 1=Green, 2=Blue, 3=Alpha
var image_set: bool = false

func _ready() -> void:
	var tooltipname: String
	match Channel:
		channelselect.RED:
			label.text = "Red Channel"
			tooltipname = "Red"
		channelselect.GREEN:
			label.text = "Green Channel"
			tooltipname = "Green"
		channelselect.BLUE:
			label.text = "Blue Channel"
			tooltipname = "Blue"
		channelselect.ALPHA:
			label.text = "Alpha Channel"
			tooltipname = "Alpha"
	channel_select.tooltip_text = "Choose the color channel in the imported image to pack into the final image's " + tooltipname + " channel."

func _on_button_pressed() -> void:
	file_dialog.show()

func _on_file_dialog_file_selected(path: String) -> void:
	load_image(path)

func _on_channel_select_item_selected(index: int) -> void:
	match index:
		0:
			channeltouse = 0
			texture_rect.set_instance_shader_parameter("mode", 1)
			image_channel_change.emit(Channel, channeltouse)
		1:
			channeltouse = 1
			texture_rect.set_instance_shader_parameter("mode", 2)
			image_channel_change.emit(Channel, channeltouse)
		2:
			channeltouse = 2
			texture_rect.set_instance_shader_parameter("mode", 3)
			image_channel_change.emit(Channel, channeltouse)
		3:
			channeltouse = 3
			texture_rect.set_instance_shader_parameter("mode", 4)
			image_channel_change.emit(Channel, channeltouse)

func load_image(path: String) -> void:
	var image = Image.load_from_file(path)
	texture_rect.texture = ImageTexture.create_from_image(image)
	image_set = true
	image_changed.emit(Channel)

func reset_image() -> void:
	var whiteimg = preload("res://assets/whitecolor.png")
	texture_rect.texture = whiteimg
	image_set = false
	channel_select.select(0)

func _on_reset_button_pressed() -> void:
	reset_image()
