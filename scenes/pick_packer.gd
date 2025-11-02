extends Control

@onready var red: TextureLookup = $GridContainer/Red
@onready var blue: TextureLookup = $GridContainer/Blue
@onready var green: TextureLookup = $GridContainer/Green
@onready var alpha: TextureLookup = $GridContainer/Alpha
@onready var final_texture: TextureRect = $VBoxContainer/FinalTexture
@onready var file_dialog: FileDialog = $FileDialog


var imagetex: ImageTexture
var image: Image
var image_height: int
var image_width: int
var image_size_set: bool = false

var redimage: Image
var greenimage: Image
var blueimage: Image
var alphaimage: Image

func _ready() -> void:
	red.image_changed.connect(changeimage)
	blue.image_changed.connect(changeimage)
	green.image_changed.connect(changeimage)
	alpha.image_changed.connect(changeimage)
	
	red.image_size_changed.connect(_change_image_size)
	blue.image_size_changed.connect(_change_image_size)
	green.image_size_changed.connect(_change_image_size)
	alpha.image_size_changed.connect(_change_image_size)
	
	get_tree().root.files_dropped.connect(_on_files_dropped)
	
	image = Image.new()
	imagetex = ImageTexture.new()
	image = Image.create_empty(1024,1024,false,Image.FORMAT_RGBA8)
	imagetex = ImageTexture.create_from_image(image)
	imagetex.set_image(image)
	final_texture.texture = imagetex
	changeimage(true)

func _on_button_pressed() -> void:
	file_dialog.show()

func changeimage(updateimages: bool) -> void:
	var width = image.get_width()
	var height = image.get_height()
	
	if updateimages:
		redimage = red.texture_rect.texture.get_image()
		if redimage.is_compressed():
			redimage.decompress()
		blueimage = blue.texture_rect.texture.get_image()
		if blueimage.is_compressed():
			blueimage.decompress()
		greenimage = green.texture_rect.texture.get_image()
		if greenimage.is_compressed():
			greenimage.decompress()
		alphaimage = alpha.texture_rect.texture.get_image()
		if alphaimage.is_compressed():
			alphaimage.decompress()
	
	for y in range(height):
		for x in range(width):
			var newcolor: Color
			newcolor.r = _get_pixel_of_channel(red.channeltouse, redimage, x, y)
			newcolor.g = _get_pixel_of_channel(green.channeltouse, greenimage, x, y)
			newcolor.b = _get_pixel_of_channel(blue.channeltouse, blueimage, x, y)
			newcolor.a = _get_pixel_of_channel(alpha.channeltouse, alphaimage, x, y)
			image.set_pixel(x,y,newcolor)
	imagetex.update(image)

func _get_pixel_of_channel(channel: int, img: Image, x: int, y: int) -> float:
	match channel:
		0:
			return img.get_pixel(x,y).r
		1:
			return img.get_pixel(x,y).g
		2:
			return img.get_pixel(x,y).b
		3:
			return img.get_pixel(x,y).a
	return img.get_pixel(x,y).r

func _on_file_dialog_file_selected(path: String) -> void:
	image.save_png(path)

func _on_files_dropped(_files):
	if red.panel_container.get_global_rect().has_point(get_global_mouse_position()):
		red.load_image(_files[0])
		return
	elif green.panel_container.get_global_rect().has_point(get_global_mouse_position()):
		green.load_image(_files[0])
		return
	elif blue.panel_container.get_global_rect().has_point(get_global_mouse_position()):
		blue.load_image(_files[0])
		return
	elif alpha.panel_container.get_global_rect().has_point(get_global_mouse_position()):
		alpha.load_image(_files[0])
		return

func _change_image_size(width: int, height: int) -> void:
	if image_size_set: return
	
	image_width = width
	image_height = height
	image.resize(width, height)
	imagetex.set_image(image)
	image_size_set = true
	#TODO: make this whole app image size agnostic!
	#TODO: handle images of differing sizes being opened.
