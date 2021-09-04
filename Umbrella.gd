extends Node2D


signal grabbed

var has_emitted_grabbed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_MouseGrabArea_mouse_entered():
	print("hello there")
	if not has_emitted_grabbed:
		emit_signal("grabbed")
		has_emitted_grabbed = true
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
