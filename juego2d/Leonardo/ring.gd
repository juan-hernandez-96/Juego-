extends Area2D

@export var game_manager_path: NodePath
@onready var ring_sfx: AudioStreamPlayer = $ring_sfx
@onready var timer = $Timer  # Opcional

var game_manager

func _ready():
    game_manager = get_node(game_manager_path)
    $Ring_Animation.play("circle")

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("jugador"):
        ring_sfx.play()
        game_manager.sumar_anillo()
        $CollisionShape2D.disabled = true
        timer.start()  # o simplemente usa queue_free() si no tienes Timer

func _on_timer_timeout():
    queue_free()
