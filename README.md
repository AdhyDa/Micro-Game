<p align="right">
  <b>Bahasa Indonesia</b> | <a href="README-en.md">English</a>
</p>

# Cavern Reveal — 2D Pixel Action Platformer (Microgame)

[![Godot Engine](https://img.shields.io/badge/Godot_Engine-4.7.2-478CBF?style=for-the-badge&logo=godot-engine&logoColor=white)](https://godotengine.org/)
[![Style](https://img.shields.io/badge/Art_Style-16--bit_Pixel_Art-purple?style=for-the-badge)]()
[![Platform](https://img.shields.io/badge/Platform-PC_%2F_Desktop-brightgreen?style=for-the-badge)]()
[![Status](https://img.shields.io/badge/Status-Completed-success?style=for-the-badge)]()

> **Microgame Team Intro** — Game *2D Side-Scrolling Action Platformer* yang dibangun menggunakan **Godot Engine 4.7.2**. Pemain mengendalikan seorang Ksatria Biru (*Blue Knight*) menjelajahi kompleks gua bawah tanah multi-bioma, bertarung melawan musuh kroco hingga bos monster, mengumpulkan *item*, serta mengaktifkan titik *trigger* pengenalan tim.

---

## Gameplay Overview

Dalam game ini, pemain harus menelusuri gua raksasa yang terbagi menjadi 4 zona bioma unik. Di sepanjang perjalanan, pemain dapat memicu kartu profil pengembang, memulihkan *Health Bar* menggunakan *Apple Heal*, mengumpulkan *Skull Collectibles*, melompati jebakan *Spikes*, serta bertarung melawan musuh biasa (*Kroco*) hingga *Boss* di arena puncak.

---

## Fitur Utama Game & Mekanik Teknis

- **Player & Combat System (`player.gd`):** Ksatria Biru dengan pergerakan *fluid*, *Health Bar*, tebasan pedang, serta regenerasi nyawa jika mengambil *item* pemulih.
- **Multi-Tier Enemy AI:**
  - **Enemy Kroco (`enemy_kroco.gd`):** Prajurit Tengkorak biasa yang melakukan patroli dan mengejar pemain saat memasuki area terdeteksi.
  - **Enemy Boss (`enemy_boss.gd`):** Bos monster dengan ketahanan *HP* lebih tinggi dan pola serangan mematikan di akhir level.
- **Dynamic Team Reveal UI (`uiprofile_*.gd`):**
  - **Aksa Profile Trigger (`uiprofile_aksa.gd`):** Menampilkan profil Project Leader & Level Designer.
  - **Miko Profile Trigger (`uiprofile_miko.gd`):** Menampilkan profil Lead Programmer.
  - **Farel Profile Trigger (`uiprofile_farel.gd`):** Menampilkan profil Lead Artist.
- **Interactive Environmental Items & Hazards:**
  - **Apple Heal (`apple_heal.gd`):** *Collectible item* buah apel yang memulihkan *Health Bar* pemain.
  - **Spike Hazard (`spike.gd`):** Duri-duri berbahaya yang memberikan *damage* saat disentuh.
  - **Skull Collectibles (`skull.gd`, `skull_2.gd`, `skull_3.gd`):** Koleksi tengkorak tersembunyi sebagai poin tambahan.
  - **Arena Trigger (`trigger_arena.gd`):** Memicu penguncian arena saat pemain memasuki area *Boss Fight*.

---

## Kontrol Permainan

| Tombol Keyboard | Aksi / Fungsi |
| :--- | :--- |
| **`A` / `D`** | Bergerak ke Kiri / Kanan |
| **`W` / `S`** | Naik / Turun Tangga |
| **`Space`** | Melompat |
| **`Left Click`** | Tebasan Pedang (*Melee Attack*) |

---

## Desain Level & 4 Zona Bioma (`game1.tscn`)

Peta permainan disusun dalam satu *Scene* utama (`game1.tscn`) yang terbagi menjadi 4 area beruntun dari kiri ke kanan:

1. **Zona 1: Ruined Brick Catacombs (Spawn & Aksa Profile)**
   - **Visual:** Balok bata tua cokelat, platform kayu, dan latar belakang gua batu.
   - **Mekanik:** Titik *spawn* awal, tutorial kontrol dasar, serta interaksi `uiprofile_aksa`.
2. **Zona 2: Overgrown Grass Cavern (Farel Profile & Apple Heal)**
   - **Visual:** Bukit tanah berumput hijau, tanaman merambat, dan *Apple Heal*.
   - **Mekanik:** Pertarungan melawan *Enemy Kroco*, *item recovery*, dan interaksi `uiprofile_farel`.
3. **Zona 3: Deep Rocky Chasm (Miko Profile & Spike Hazards)**
   - **Visual:** Tebing terjal oranye, platform gantung melayang, dan duri tajam (`spike.gd`).
   - **Mekanik:** Tantangan platforming presisi di atas jurang dan interaksi `uiprofile_miko`.
4. **Zona 4: Dark Abyss & Boss Arena (Trigger Arena & Boss Fight)**
   - **Visual:** Area gelap bertabur *crystal/spora* dan ruang tertutup.
   - **Mekanik:** Penguncian otomatis (`trigger_arena.gd`), pertarungan puncak melawan `enemy_boss.tscn`, dan gerbang kemenangan.

---

## Anggota Kelompok & Peran

| Nama Lengkap | NIM | Peran Utama |
| :--- | :---: | :--- |
| **Adhyaksa Daudi Musthofa Akhyar** | `240533603336` | **Project Leader & Level Designer** |
| **Abraham Miko Pratama** | `240533600750` | **Game Programmer (Logic & Combat)** |
| **Farel Farizi Prunomosasi** | `240533605901` | **Game Artist (Tilemap, UI/UX & Sprites)** |

---

## Tech Stack & Management Tools

- **Game Engine:** [Godot Engine 4.7.2](https://godotengine.org/) (GDScript)
- **Version Control:** Git & [GitHub Desktop](https://desktop.github.com/)
- **Project Management:** [Trello Board](https://trello.com/) (dengan GitHub Power-Up)
- **Visual Assets:** 16-bit Cave Pixel Art, Custom Sprites, Pixel-Me Tokyo

---

## Arsitektur Direktori Proyek

```text
Micro-Game/
├── Assets/                   # Seluruh Aset Media & Grafis
│   ├── enemy/               # Sprite Musuh Kroco & Boss
│   ├── images/              # Gambar UI & Foto Profil Pixelate
│   ├── music/               # BGM & SFX
│   ├── platform/            # Tilemap & Sprite Lingkungan
│   └── player/              # Animation Sprite Ksatria Biru
├── Scenes/                   # Berkas Scene (.tscn) Godot
│   ├── Player.tscn          # Node Utama Player
│   ├── apple_heal.tscn      # Item Pemulih HP
│   ├── enemy_boss.tscn      # Entity Boss Monster
│   ├── enemy_kroco.tscn     # Entity Musuh Kroco
│   ├── game1.tscn           # Main World Level
│   ├── uiprofile_aksa.tscn  # Pop-Up UI Profil Aksa
│   ├── uiprofile_farel.tscn # Pop-Up UI Profil Farel
│   └── uiprofile_miko.tscn  # Pop-Up UI Profil Miko
├── Scripts/                  # Skrip GDScript (.gd) Logic Game
│   ├── apple_heal.gd        # Logika Tambah HP
│   ├── enemy_boss.gd        # AI State Machine Boss
│   ├── enemy_kroco.gd       # AI Patroli Kroco
│   ├── player.gd            # Controller & Combat Player
│   ├── skull*.gd            # Logic Collectible Item Skull
│   ├── spike.gd             # Hazard Collision Logic
│   ├── trigger_arena.gd     # Lock Arena Script
│   └── uiprofile_*.gd       # Trigger Script UI Reveal
├── project.godot             # Godot Engine Configuration
└── README.md                 # Dokumentasi Proyek
```

---

## Cara Menjalankan Proyek (Local Setup)

1. **Clone Repositori ini:**
   ```bash
   git clone https://github.com/AdhyDa/Micro-Game.git
   ```
2. **Buka Godot Engine 4.7.2:**
   - Jalankan **Godot Engine 4.7.2**.
   - Klik tombol **Import**, arahkan ke direktori hasil clone, dan pilih file `project.godot`.
   - Klik **Import & Edit**.
3. **Jalankan Permainan:**
   - Tekan **F5** di editor Godot untuk memuat dan memutar scene utama `Scenes/game1.tscn`.

---

*Disusun untuk memenuhi tugas perkuliahan **Microgame Team Intro** (2026).*
