**#-Juego2D-**

**👥Integrantes-.** 
- Juan Pablo Hernández Arciniega.
- Leonardo Rubén Hernández Silva.

*Descripción del juego*  

   -Plataformero 2D, intencionado a tener un leve nivle de dificultad gracias a los diferentes tipos de plataformas usadas.





**Descripcion de recursos usados**

### 🎨 Assets:

- Personaje principal
  
  [personaje.zip](https://github.com/user-attachments/files/21049092/personaje.zip)
- Plataformas
  
  [plataforma.zip](https://github.com/user-attachments/files/21049101/plataforma.zip)

- Anillos
  
  [anillo.zip](https://github.com/user-attachments/files/21049108/anillo.zip)

- Puerta
  
  [puerta de fuego (1).zip](https://github.com/user-attachments/files/21049117/puerta.de.fuego.1.zip)

- fondo para los dos niveles
  
  [fondo cielo.zip](https://github.com/user-attachments/files/21049050/fondo.cielo.zip)


### 🎵 Sonidos:

- sonido a la hora de morir
  
  [sonidodemuerte.zip](https://github.com/user-attachments/files/21049161/sonidodemuerte.zip)

- sonido a la hora de saltar
  
  [sonidospring.zip](https://github.com/user-attachments/files/21049184/sonidospring.zip)

- sonido al recoger los anillos
  
  [sonido de anillo.zip](https://github.com/user-attachments/files/21049179/sonido.de.anillo.zip)

### 💫 Efectos:
- Aparece un boton "reiniciar" para volver al nivel 1
- Se muestra un mensaje “fin del juego” al completar el nivel.







**Descripción de los códigos empleados para el funcionamiento**

📁 Personaje.gd

```gdscript

extends CharacterBody2D

# Velocidad de movimiento horizontal
var velocidad = 200
# Valor negativo para el salto (brinco hacia arriba)
var brinco = -400
# Fuerza de gravedad que afecta al personaje
var gravedad = 1000
# Contador de anillos recolectados (inicializado en 0)
var contador_anillos = 0

# Referencias a nodos hijos
@onready var marcador = $HUD/Marcador  # Etiqueta del HUD para mostrar anillos
@onready var door = $door              # Nodo de la puerta
@onready var jump: AudioStreamPlayer = $jump  # Sonido al saltar
@onready var death_sound: AudioStreamPlayer = $Death_sound  # Sonido al morir

# Se ejecuta una vez cuando la escena está lista
func _ready():
    add_to_group("jugador")  # Agrega este nodo al grupo 'jugador' para identificarlo

# Función que se llama en cada frame con física activa
func _physics_process(delta):
    # Obtiene la dirección (izquierda: -1, derecha: 1, o 0 si no se presiona nada)
    var direccion = Input.get_axis("ui_left","ui_right")
    velocity.x = direccion * velocidad  # Aplica velocidad horizontal según la dirección

    # Si el jugador está en el aire, se le aplica gravedad
    if not is_on_floor(): 
        velocity.y += gravedad * delta

    # Si el jugador presiona 'arriba' estando en el suelo, salta
    if Input.is_action_just_pressed("ui_up") and is_on_floor(): 
        velocity.y = brinco
        jump.play()  # Reproduce sonido de salto

    # Mueve al jugador con deslizamiento y manejo automático de colisiones
    move_and_slide()

# Función que se ejecuta cuando el jugador entra en una zona de muerte
func _on_zona_muerte_body_entered(body: Node2D):
    death_sound.play(2.0)  # Reproduce sonido de muerte con retardo opcional
    await get_tree().create_timer(1.0).timeout  # Espera 1 segundo
    get_tree().reload_current_scene()  # Reinicia la escena actual

# Función que se activa cuando el jugador entra en contacto con el anillo llamado 'ring11'
func _on_ring11_body_entered(body: Node2D) -> void:
    if "jugador" in body.name:
        body.hasRing = true  # Marca que el jugador tiene un anillo (si está implementado)
        queue_free()  # El anillo desaparece al recolectarlo

