extends Area2D

@export var spike_damage := 100

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		# Berikan damage ke player (player otomatis akan berkedip merah dan kebal sementara)
		body.take_damage(spike_damage)
