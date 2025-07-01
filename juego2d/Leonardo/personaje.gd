extends CharacterBody2D

var velocidad = 200
var brinco = -400
var gravedad = 1000
var contador_anillos = 0
@onready var marcador = $HUD/Marcador
@onready var door = $door  
@onready var jump: AudioStreamPlayer = $jump
@onready var death_sound: AudioStreamPlayer = $Death_sound

func _ready():
	add_to_group("jugador")

func _physics_process(delta):
	var direccion = Input.get_axis("ui_left","ui_right")
	velocity.x = direccion * velocidad
	
	if not is_on_floor(): 
		velocity.y += gravedad * delta
	
	if Input.is_action_just_pressed("ui_up") and is_on_floor(): 
		velocity.y = brinco
		jump.play()
	
	move_and_slide()

func _on_zona_muerte_body_entered(body: Node2D):
	death_sound.play(2.0)
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()


func _on_ring11_body_entered(body: Node2D) -> void:
	if "jugador" in body.name:
		body.hasRing = true
		queue_free()
