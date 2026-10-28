extends CharacterBody2D

var hp := 100 # Total darah musuh

# Fungsi ini akan dipanggil otomatis oleh pedang Player
func take_damage(amount: int) -> void:
	hp -= amount
	print("Musuh terkena hit! HP tersisa: ", hp) # Cek output di konsol
	
	# Kamu bisa memutar animasi "terluka" di sini jika ada
	
	if hp <= 0:
		die()

func die() -> void:
	print("Musuh mati!")
	# Mainkan suara atau animasi mati di sini
	queue_free() # Menghapus musuh dari game (hilang)
