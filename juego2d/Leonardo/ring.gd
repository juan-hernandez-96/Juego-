extends Area2D
@onready var ring_sfx: AudioStreamPlayer = $ring_sfx

func _ready():
 $Ring_Animation.play("circle")


func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("jugador"):
        ring_sfx.play()
        $CollisionShape2D.disabled = true
        await get_tree().create_timer(0.2).timeout
        queue_free()
