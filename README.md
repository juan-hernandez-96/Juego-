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


**Descripción de cada escena (nivel, plataforma, personaje, etc y una imagen referente)**




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

 ```

📁 Plataforma.gd


```gdscript

extends Area2D

# Enumerador para definir tipos de plataforma
enum TipoPlataforma {FIJA, OSCILATORIA, FRAGIL, REBOTE, CAIDA}

# Variables exportables visibles en el editor
@export var type: TipoPlataforma = TipoPlataforma.FIJA     # Tipo de plataforma
@export var direccion := "vertical"                         # Dirección del movimiento si es oscilatoria
@export var fuerza_rebote := 2.0                            # Multiplicador para rebote del jugador
@export var desplazamiento := 100                           # Distancia del movimiento oscilatorio
@export var duracion := 2.0                                 # Duración de ida/vuelta en oscilación

# Nodo de sonido para plataformas de rebote
@onready var jump_from: AudioStreamPlayer = $jump_from

# Guarda la posición inicial de la plataforma
var posicion_inicial := Vector2.ZERO

# Se ejecuta cuando inicia la escena
func _ready():
    posicion_inicial = position  # Se guarda la posición de inicio
    actualizar_plataforma()      # Se aplica el comportamiento y color según el tipo
    monitorable = true           # Activa la detección de cuerpos que entren en el área
    monitoring = true

# Define el comportamiento visual y lógico según el tipo de plataforma
func actualizar_plataforma():
    match type:
        TipoPlataforma.FIJA:
            $Sprite2D.modulate = Color.NAVY_BLUE  # Color azul oscuro para plataforma fija
        TipoPlataforma.OSCILATORIA:
            $Sprite2D.modulate = Color.DARK_ORANGE  # Color naranja para oscilatoria
            oscilar()  # Se llama a la función de movimiento oscilante
        TipoPlataforma.FRAGIL:
            $Sprite2D.modulate = Color.NAVY_BLUE  # Igual que la fija, pero se rompe
        TipoPlataforma.REBOTE:
            $Sprite2D.modulate = Color.YELLOW  # Amarilla para indicar rebote
        TipoPlataforma.CAIDA:
            $Sprite2D.modulate = Color.NAVY_BLUE  # Azul para plataforma que cae

# Detecta cuándo un cuerpo (jugador) entra en contacto con la plataforma
func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("jugador"):  # Solo reacciona si el que entra es el jugador
        match type: 
            TipoPlataforma.FRAGIL:
                # Espera 0.25 segundos y luego elimina la plataforma (se rompe)
                await get_tree().create_timer(0.25).timeout
                queue_free()
            TipoPlataforma.REBOTE:
                if body.has_method("puede_rebotar"):
                    # Si el jugador tiene un método personalizado de rebote
                    jump_from.play()  # Reproduce sonido de rebote
                    body.puede_rebotar(fuerza_rebote)  # Llama a ese método con fuerza personalizada
                else:
                    # Si no tiene método propio, aplica rebote modificando la velocidad vertical
                    body.velocity.y = body.brinco * fuerza_rebote
            TipoPlataforma.CAIDA:
                # Crea animación que baja la plataforma hacia abajo (efecto de caída)
                var tween = create_tween()
                tween.tween_property(self, "position:y", position.y + 200, 1.0)

# Función para plataformas que se mueven automáticamente de forma oscilatoria
func oscilar():
    var tween = create_tween()
    tween.set_loops()  # Hace que la animación se repita indefinidamente

    if direccion == "vertical":
        # Movimiento arriba y abajo
        tween.tween_property(self, "position:y", posicion_inicial.y + desplazamiento, duracion)\
            .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
        tween.tween_property(self, "position:y", posicion_inicial.y - desplazamiento, duracion)\
            .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    elif direccion == "horizontal":
        # Movimiento izquierda y derecha
        tween.tween_property(self, "position:x", posicion_inicial.x + desplazamiento, duracion)\
            .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
        tween.tween_property(self, "position:x", posicion_inicial.x - desplazamiento, duracion)\
            .set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

```

📁 puerta.gd


```gdscript

extends Area2D  # Nodo que detecta colisiones cuando el jugador entra al área de la puerta

# Ruta exportable para obtener el nodo GameManager (para verificar progreso del jugador)
@export var game_manager_path: NodePath

# Ruta exportable para obtener el nodo HUD (para mostrar mensajes como "fin del juego")
@export var hud_path: NodePath

# Variables que almacenarán las referencias a los nodos una vez cargados
var game_manager
var hud

# Se ejecuta una vez cuando la escena está lista
func _ready():
    # Obtiene el nodo GameManager usando la ruta especificada en el editor
    game_manager = get_node(game_manager_path)
    
    # Obtiene el nodo HUD usando la ruta especificada en el editor
    hud = get_node(hud_path)
    
    # Conecta la señal de colisión del área (cuando algo entra) con la función personalizada
    connect("body_entered", Callable(self, "_on_body_entered"))

# Función que se ejecuta automáticamente cuando otro nodo entra en el área de la puerta
func _on_body_entered(body):
    # Verifica si el cuerpo que entró pertenece al grupo "jugador"
    if body.is_in_group("jugador"):
        # Muestra en consola el estado de la puerta (útil para depuración)
        print("puerta_desbloqueada =", game_manager.puerta_desbloqueada)
        
        # Si el jugador ha recolectado los anillos necesarios y la puerta está desbloqueada...
        if game_manager.puerta_desbloqueada:
            # Llama a la función del HUD para mostrar el mensaje de fin de juego
            hud.mostrar_fin_juego()
        else:
            # Si aún no se desbloquea la puerta, muestra un mensaje en consola
            print("Te faltan anillos para desbloquear la puerta")

```

📁 Anillos.gd


```gdscript

extends Area2D  # Nodo que detecta colisiones (representa el anillo en el juego)

# Ruta al GameManager que lleva el conteo de anillos
@export var game_manager_path: NodePath

# Reproduce el sonido cuando el jugador recolecta el anillo
@onready var ring_sfx: AudioStreamPlayer = $ring_sfx

# Temporizador para eliminar el anillo tras una breve pausa (opcional)
@onready var timer = $Timer

# Variable para almacenar referencia al GameManager
var game_manager

# Se ejecuta cuando la escena inicia
func _ready():
    game_manager = get_node(game_manager_path)  # Conecta con el GameManager usando la ruta exportada
    $Ring_Animation.play("circle")  # Reproduce animación del anillo (debe tener una animación llamada "circle")

# Se ejecuta cuando otro cuerpo entra en contacto con el anillo
func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("jugador"):  # Solo reacciona si el que entra es el jugador
        ring_sfx.play()  # Reproduce sonido del anillo
        game_manager.sumar_anillo()  # Llama al GameManager para aumentar el contador
        $CollisionShape2D.disabled = true  # Desactiva la colisión para evitar múltiples recogidas
        timer.start()  # Inicia el temporizador que destruirá el anillo (si no se usa, puedes usar queue_free() directamente)

# Se ejecuta cuando el temporizador llega a 0
func _on_timer_timeout():
    queue_free()  # Elimina el anillo de la escena

```

📁 Hud.gd

```gdscript

extends CanvasLayer  # Este nodo se usa para elementos de la interfaz gráfica (HUD), siempre visible en pantalla

# Referencias a los nodos hijos del HUD, asignadas automáticamente cuando la escena está lista
@onready var label_fin = $LabelFinJuego             # Etiqueta que muestra el texto "¡Fin del juego!"
@onready var boton_reiniciar = $BotonReiniciar      # Botón para reiniciar el nivel
@onready var label_marcador = $LabelMarcador        # Etiqueta que muestra la cantidad de anillos recolectados

# Esta función se ejecuta una vez al iniciar la escena
func _ready():
    label_fin.visible = false                       # Oculta el mensaje de fin de juego al inicio
    boton_reiniciar.visible = false                 # Oculta el botón de reinicio al inicio
    boton_reiniciar.connect("pressed", Callable(self, "_on_BotonReiniciar_pressed"))  
    # Conecta el botón de reinicio para ejecutar una función cuando se presiona

# Esta función se llama cuando el jugador gana el juego (por ejemplo, al recolectar todos los anillos)
func mostrar_fin_juego():
    label_fin.visible = true                        # Muestra el mensaje de fin de juego
    boton_reiniciar.visible = true                  # Muestra el botón de reinicio
    get_tree().paused = true                        # Pausa el juego (todo se detiene)

# Esta función se llama cuando se presiona el botón de reinicio
func _on_BotonReiniciar_pressed():
    get_tree().paused = false                       # Quita la pausa del juego
    get_tree().change_scene_to_file("res://Juan Hernández/nivel1.tscn")  
    # Cambia la escena actual y carga de nuevo el nivel 1

# Esta función actualiza el marcador de anillos en pantalla
func actualizar_marcador(cantidad):
    label_marcador.text = "Anillos: " + str(cantidad)  
    # Muestra el número actual de anillos recolectados en el HUD


```
**Redactar de manera detallada por integrante, las dificultades que se tuvieron al usar las herramientas colaborativas**

LEONARDO RUBEN HERNANDEZ SILVA

 Las dificultades principales que tuve fue el manejo de git en VS Code y la sincronización con GitHub porque al inicio me costó entender cómo realizar correctamente las operaciones básicas desde VS Code como hacer commits y eso me provocó que algunas veces no subiera mis cambios a GitHub o sobrescribiera archivos sin querer o borraba cosas sin querer.





**Una breve conclusión del uso e importancia de las herramientas colaborativas para el programador**
