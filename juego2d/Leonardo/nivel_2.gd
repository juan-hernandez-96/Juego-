extends Node2D
var contador_anillos = 0

func sumar_anillo():
	contador_anillos += 1
	$HUD/Marcador.text = "Anillos: " + str(contador_anillos)
