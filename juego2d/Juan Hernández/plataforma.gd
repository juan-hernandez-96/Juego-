extends Area2D

enum TipoPlataforma { FIJA, OSCILATORIA, FRAGIL, REBOTE, CAIDA }
@export var type: TipoPlataforma = TipoPlataforma.FIJA
@export var fuerza_rebote := 2.0 

func _ready():
	monitorable = true
	monitoring = true
	actualizar_plataforma()

func actualizar_plataforma():
	match type:
		TipoPlataforma.FIJA:
			$Sprite2D.modulate = Color.DIM_GRAY
		TipoPlataforma.OSCILATORIA:
			$Sprite2D.modulate = Color.REBECCA_PURPLE
			iniciar_oscilar()
		TipoPlataforma.FRAGIL:
			$Sprite2D.modulate = Color.GHOST_WHITE
		TipoPlataforma.REBOTE, TipoPlataforma.CAIDA:
			$Sprite2D.modulate = Color.DARK_ORANGE

func _on_Area2D_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		match type:
			TipoPlataforma.FRAGIL:
				await get_tree().create_timer(0.1).timeout
				queue_free()
			TipoPlataforma.REBOTE:
				if body.has_method("puede_rebotar"):
					body.puede_rebotar(fuerza_rebote)
				elif "velocity" in body and "brinco" in body:
					body.velocity.y = body.brinco * fuerza_rebote
			TipoPlataforma.CAIDA:
				var tween = create_tween()
				tween.tween_property(self, "position:y", position.y + 200, 1.0)


func iniciar_oscilar():
	var tween = create_tween()
	tween.set_loops()  # Lo hace infinito
	tween.tween_property(self, "position:x", position.x + 80, 1.5).as_relative()
	tween.tween_property(self, "position:x", position.x - 80, 1.5).as_relative()
	tween.tween_property(self, "position:y", position.y - 100, 1.5).as_relative()
	tween.tween_property(self, "position:y", position.y + 100, 1.5).as_relative()
