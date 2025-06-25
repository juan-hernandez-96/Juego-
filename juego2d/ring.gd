extends Area2D
@onready var ring_sfx: AudioStreamPlayer = $ring_sfx

func _ready():
	$Ring_Animation.play("circle")
