extends Button

func _pressed():
    get_tree().paused = false  # Reanuda el juego
    get_tree().reload_current_scene()  # Recarga la escena actual para reiniciar
