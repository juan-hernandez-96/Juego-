extends Area2D

func _ready():
	# Conectar señal correctamente
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	print("Entró:", body.name)  # Para probar si funciona

	if body.name == "Personaje":  # Cambia a lo que diga tu jugador
		var hud = get_node("/root/NIVEL2/HUD")  # Cambia Nivel1 si es necesario
		hud.get_node("LabelFinal").visible = true
		hud.get_node("BotonReiniciar").visible = true
