extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "Personaje":
		get_tree().change_scene_to_file("res://Nivel2.tscn")      # poner aqui la ruta de mi compañero
