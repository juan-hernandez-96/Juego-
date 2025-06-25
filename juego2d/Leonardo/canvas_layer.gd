extends CanvasLayer

@onready var label_fin = $LabelFinJuego
@onready var boton_reiniciar = $BotonReiniciar

func _ready():
	label_fin.visible = false
	boton_reiniciar.visible = false
	boton_reiniciar.connect("pressed", Callable(self, "_on_BotonReiniciar_pressed"))

func mostrar_fin_juego():
	label_fin.visible = true
	boton_reiniciar.visible = true
	get_tree().paused = true  

func _on_BotonReiniciar_pressed():
	get_tree().paused = false
	get_tree().change_scene("")  # Cambia la ruta por la de tu nivel 1
