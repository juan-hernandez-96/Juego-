extends Area2D

enum TipoPlataforma {FIJA, OSCILATORIA, FRAGIL, REBOTE, CAIDA}
@export var type: TipoPlataforma = TipoPlataforma.FIJA
@export var direccion := "vertical" # puede ser "vertical" o "horizontal"
@export var fuerza_rebote := 2.0 
@export var desplazamiento := 100
@export var duracion := 2.0

var posicion_inicial := Vector2.ZERO

func _ready():
	posicion_inicial = position
	actualizar_plataforma()
	monitorable = true
	monitoring = true

func actualizar_plataforma():
	match type:
		TipoPlataforma.FIJA:
			$Sprite2D.modulate = Color.NAVY_BLUE
		TipoPlataforma.OSCILATORIA:
			$Sprite2D.modulate = Color.DARK_ORANGE
			oscilar()
		TipoPlataforma.FRAGIL:
			$Sprite2D.modulate = Color.NAVY_BLUE
		TipoPlataforma.REBOTE:
			$Sprite2D.modulate = Color.YELLOW
		TipoPlataforma.CAIDA:
			$Sprite2D.modulate = Color.NAVY_BLUE

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		match type: 
			TipoPlataforma.FRAGIL:
				await get_tree().create_timer(0.25).timeout
				queue_free()
			TipoPlataforma.REBOTE:
				if body.has_method("puede_rebotar"):
					body.puede_rebotar(fuerza_rebote)
				else:
					body.velocity.y = body.brinco * fuerza_rebote
			TipoPlataforma.CAIDA:
				var tween = create_tween()
				tween.tween_property(self, "position:y", position.y + 200, 1.0)

func oscilar():
	var tween = create_tween()
	tween.set_loops()

	if direccion == "vertical":
		tween.tween_property(self, "position:y", posicion_inicial.y + desplazamiento, duracion).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "position:y", posicion_inicial.y - desplazamiento, duracion).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	elif direccion == "horizontal":
		tween.tween_property(self, "position:x", posicion_inicial.x + desplazamiento, duracion).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "position:x", posicion_inicial.x - desplazamiento, duracion).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
