extends CharacterBody2D

var velocidad = 200
var brinco = -400
var gravedad = 1000

func _ready():
	add_to_group("character")

func _physics_process(delta):
	var direccion = Input.get_axis("ui_left","ui_right")
	velocity.x = direccion * velocidad
	
	if not is_on_floor(): 
		velocity.y += gravedad * delta
	
	if Input.is_action_just_pressed("ui_up") and is_on_floor(): 
		velocity.y = brinco
	
	move_and_slide()



func _on_door_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://nivel1.tscn")
