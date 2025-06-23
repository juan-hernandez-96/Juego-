extends Node2D

var contador_anillos = 0
@onready var marcador = $HUD/Marcador
@onready var door = $door  

func sumar_anillo():
	contador_anillos += 1
	marcador.text = "Anillos: " + str(contador_anillos)

	if contador_anillos == 5:
		print("¡Puerta desbloqueada!")
		door.get_node("CollisionShape2D").disabled = true  # Solo desactiva la colisión
