extends Area2D

@export var heal_amount := 10 
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# Gunakan get_node_or_null agar aman jika node gambarmu bernama Sprite2D atau AnimatedSprite2D
@onready var sprite = get_node_or_null("AnimatedSprite2D") if has_node("AnimatedSprite2D") else get_node_or_null("Sprite2D")

func _ready() -> void:
	# Pastikan sinyal terhubung secara otomatis via kode
	if not is_connected("body_entered", _on_body_entered):
		connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	print("Apel bersentuhan dengan: ", body.name, " | Apakah masuk grup player? ", body.is_in_group("player"))
	
	if body.is_in_group("player"):
		if body.has_method("heal"):
			body.heal(heal_amount)
			
			# Matikan collision agar tidak bisa diambil dua kali
			if collision_shape:
				collision_shape.set_deferred("disabled", true)
				
			# Sembunyikan gambar apel
			if sprite:
				sprite.visible = false
				
			# Putar suara jika ada
			if audio_player and audio_player.stream:
				audio_player.play()
				await audio_player.finished
				
			queue_free()
		else:
			print("ERROR: Player menyentuh apel, tapi Player tidak memiliki fungsi heal() di script player.gd!")
