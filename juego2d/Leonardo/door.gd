extends Area2D

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "Personaje":
		print("Puerta desbloqueada")
		var contenedor = get_node("HUD/ContenedorFinal")
		if contenedor:
			print("✅ ContenedorFinal encontrado")
			contenedor.visible = true
		else:
			print("❌ No se encontró ContenedorFinal")
