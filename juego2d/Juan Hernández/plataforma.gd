extends Area2D

enum TipoPlataforma {FIJA, OSCILATORIA, FRAGIL, REBOTE, CAIDA, FIJA_INVISIBLE, REBOTE_INVISIBLE}
@export var type: TipoPlataforma = TipoPlataforma.FIJA;
@export var fuerza_rebote := 2.0 
@onready var jump_from: AudioStreamPlayer = $jump_from


func _ready():
	actualizar_plataforma()
	monitorable = true
	monitoring = true
	
func actualizar_plataforma():
	match type:
		TipoPlataforma.FIJA:
			$Sprite2D.modulate = Color. DIM_GRAY
		TipoPlataforma.FIJA_INVISIBLE:
			$Sprite2D.modulate = Color. TRANSPARENT
		TipoPlataforma.OSCILATORIA:
			$Sprite2D.modulate = Color. REBECCA_PURPLE
			oscilar()
		TipoPlataforma.FRAGIL:
			$Sprite2D.modulate = Color. GHOST_WHITE
		TipoPlataforma.REBOTE:
			$Sprite2D.modulate = Color. DARK_ORANGE
		TipoPlataforma.REBOTE_INVISIBLE:
			$Sprite2D.modulate = Color. TRANSPARENT
		TipoPlataforma.CAIDA:
			$Sprite2D.modulate = Color. DARK_ORANGE
		

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		
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
			TipoPlataforma.REBOTE_INVISIBLE:
				if body.has_method("puede_rebotar"):
					body.puede_rebotar(fuerza_rebote)
				else: 
					body.velocity.y = body.brinco * fuerza_rebote
	
	
func oscilar():
	var tween = create_tween()
	tween.tween_property(self,"position:x",position.x + 90,2)
	tween.tween_property(self,"position:y",position.y - 100,2)
	tween.tween_property(self,"position:x",position.x - 90,2)
	tween.tween_property(self,"position:y",position.y + 100,2)
	tween.set_loops() 
