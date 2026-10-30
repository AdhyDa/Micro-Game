extends CanvasLayer # Atau extends Control jika root-nya Control

func _ready() -> void:
	# Memastikan game benar-benar ter-pause saat UI ini muncul
	get_tree().paused = true

# Hubungkan sinyal "pressed" dari TextureButton (Tombol EXIT) ke fungsi ini
func _on_texture_button_pressed() -> void:
	# 1. Jalankan kembali game
	get_tree().paused = false
	# 2. Hapus UI dari layar
	queue_free()
