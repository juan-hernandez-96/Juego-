extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Jugador":
		var ui = get_parent().get_node("UI")
		if ui:
			ui.get_node("Mensaje").text = "¡Fin del juego!"
			ui.get_node("Mensaje").visible = true
			ui.get_node("BotonReiniciar").visible = true
			get_tree().paused = true
		else:
			print("No se encontró el nodo UI")
