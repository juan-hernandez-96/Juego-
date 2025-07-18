extends Area2D

enum TipoPlataforma {FIJA, OSCILATORIA, FRAGIL, REBOTE, CAIDA}
@export var type: TipoPlataforma = TipoPlataforma.FIJA;
@export var fuerza_rebote := 2.0 
@onready var jump_from: AudioStreamPlayer = $jump_from


func _ready():
	monitorable = true
	monitoring = true
	actualizar_plataforma()

func actualizar_plataforma():
	match type:
		TipoPlataforma.FIJA:
			$Sprite2D.modulate = Color. DIM_GRAY
		TipoPlataforma.OSCILATORIA:
			$Sprite2D.modulate = Color.REBECCA_PURPLE
			oscilar()
		TipoPlataforma.FRAGIL:
			$Sprite2D.modulate = Color. GHOST_WHITE
		TipoPlataforma.REBOTE:
			$Sprite2D.modulate = Color. DARK_ORANGE
		TipoPlataforma.CAIDA:
			$Sprite2D.modulate = Color. DARK_ORANGE
		

func _on_Area2D_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		match type:
			TipoPlataforma.FRAGIL:
				await get_tree().create_timer(0.1).timeout
				queue_free()
			TipoPlataforma.REBOTE:
				if body.has_method("puede_rebotar"):
					jump_from.play()
					body.puede_rebotar(fuerza_rebote)
				else: 
					body.velocity.y = body.brinco * fuerza_rebote 
			TipoPlataforma.CAIDA:
				var tween = create_tween()
				tween.tween_property(self, "position:y", position.y + 200, 1.0)
	
	
func oscilar():
	var tween = create_tween()
	tween.tween_property(self,"position:x",position.x + 80,2)
	tween.tween_property(self,"position:y",position.y - 100,2)
	tween.tween_property(self,"position:x",position.x - 80,2)
	tween.tween_property(self,"position:y",position.y + 100,2)
	tween.set_loops() 


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
