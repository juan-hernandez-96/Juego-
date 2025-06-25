extends Node

var anillos_recolectados : int = 0
var anillos_para_desbloquear : int = 5
var puerta_desbloqueada : bool = false

@export var hud_path : NodePath
var hud

func _ready():
	hud = get_node(hud_path)
	actualizar_hud()

func sumar_anillo():
	anillos_recolectados += 1
	print("Anillos:", anillos_recolectados)
	actualizar_hud()
	if anillos_recolectados >= anillos_para_desbloquear:
		puerta_desbloqueada = true
		print("Puerta desbloqueada!")

func actualizar_hud():
	if hud:
		hud.actualizar_marcador(anillos_recolectados)
