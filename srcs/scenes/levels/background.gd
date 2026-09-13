@tool
extends TextureRect
@export var backgrounds : Array[Texture2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = backgrounds.pick_random()
