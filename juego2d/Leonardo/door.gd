extends Area2D

@export var game_manager_path: NodePath
@export var hud_path: NodePath

var game_manager
var hud

func _ready():
    game_manager = get_node(game_manager_path)
    hud = get_node(hud_path)
    connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
    if body.is_in_group("jugador"):
        print("puerta_desbloqueada =", game_manager.puerta_desbloqueada)
        if game_manager.puerta_desbloqueada:
            hud.mostrar_fin_juego()
        else:
            print("Te faltan anillos para desbloquear la puerta")
