extends Area2D

enum TipoPlataforma {FIJA, OSCILATORIA, FRAGIL, REBOTE, CAIDA}
@export var type: TipoPlataforma = TipoPlataforma.FIJA
@export var fuerza_rebote := 2.0 

var posicion_inicial := Vector2.ZERO
var desplazamiento := 100
var duracion := 2.0

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
			$Sprite2D.modulate = Color.NAVY_BLUE
			oscilar()
		TipoPlataforma.FRAGIL:
			$Sprite2D.modulate = Color.NAVY_BLUE
		TipoPlataforma.REBOTE:
			$Sprite2D.modulate = Color.NAVY_BLUE
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

	# Movimiento de izquierda a derecha y regreso
	tween.tween_property(self, "position:x", posicion_inicial.x + desplazamiento, duracion)
	tween.tween_property(self, "position:x", posicion_inicial.x - desplazamiento, duracion)
	
