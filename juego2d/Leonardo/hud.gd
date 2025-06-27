extends CanvasLayer

@onready var label_fin = $LabelFinJuego
@onready var boton_reiniciar = $BotonReiniciar
@onready var label_marcador = $LabelMarcador

func _ready():
    label_fin.visible = false
    boton_reiniciar.visible = false
    label_marcador.text = "Anillos: 0"
    boton_reiniciar.connect("pressed", Callable(self, "_on_BotonReiniciar_pressed"))

func actualizar_marcador(cantidad: int):
    label_marcador.text = "Anillos: %d" % cantidad

func mostrar_fin_juego():
    label_fin.visible = true
    boton_reiniciar.visible = true
    get_tree().paused = true  # pausa el juego

func _on_BotonReiniciar_pressed():
    get_tree().paused = false
    get_tree().change_scene("res://Leonardo/")  # Cambia por tu ruta
