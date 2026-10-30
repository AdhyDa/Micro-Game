# Cavern Reveal — 2D Pixel Action Platformer (Microgame)

[![Godot Engine](https://img.shields.io/badge/Godot_Engine-4.7.2-478CBF?style=for-the-badge&logo=godot-engine&logoColor=white)](https://godotengine.org/)
[![Style](https://img.shields.io/badge/Art_Style-16--bit_Pixel_Art-purple?style=for-the-badge)]()
[![Platform](https://img.shields.io/badge/Platform-PC_%2F_Desktop-brightgreen?style=for-the-badge)]()
[![Status](https://img.shields.io/badge/Status-Completed-success?style=for-the-badge)]()

**Language / Bahasa:** [Bahasa Indonesia](README.md) | **[English](README-en.md)**

---

> **Microgame Team Intro** — A 2D Side-Scrolling Action Platformer built using **Godot Engine 4.7.2**. Players control a **Blue Knight** exploring a multi-biome underground cavern complex, fighting minion enemies up to boss monsters, collecting items, and activating team introduction trigger points.

---

## Gameplay Overview

In this game, players traverse a massive underground cavern divided into 4 unique biome zones. Along the journey, players can trigger developer profile cards, restore their **Health Bar** using **Apple Heal**, collect **Skull Collectibles**, leap over hazardous **Spike** traps, and combat regular minion enemies (*Kroco*) leading up to a climax **Boss Fight**.

---

## Key Features & Technical Mechanics

* **Player & Combat System (`player.gd`):** A Blue Knight featuring fluid platformer physics, a dynamic Health Bar, sword slashing combat, and health recovery upon collecting healing items.
* **Multi-Tier Enemy AI:**
  * **Enemy Kroco (`enemy_kroco.gd`):** Standard Skeleton Warriors that patrol platforms and engage the player upon entering their detection radius.
  * **Enemy Boss (`enemy_boss.gd`):** High-HP Boss Monster with aggressive attack patterns located in the final chamber.
* **Dynamic Team Reveal UI (`uiprofile_*.gd`):**
  * **Aksa Profile Trigger (`uiprofile_aksa.gd`):** Displays the Project Leader & Level Designer profile.
  * **Miko Profile Trigger (`uiprofile_miko.gd`):** Displays the Lead Programmer profile.
  * **Farel Profile Trigger (`uiprofile_farel.gd`):** Displays the Lead Artist profile.
* **Interactive Environmental Items & Hazards:**
  * **Apple Heal (`apple_heal.gd`):** Collectible apple item that restores player health.
  * **Spike Hazard (`spike.gd`):** Hazardous environment spikes dealing immediate contact damage.
  * **Skull Collectibles (`skull.gd`, `skull_2.gd`, `skull_3.gd`):** Hidden skull pickups serving as score collectibles.
  * **Arena Trigger (`trigger_arena.gd`):** Locks the arena doors once the player enters the final Boss room.

---

## Game Controls

| Keyboard Key | Action / Function |
| :--- | :--- |
| **`A` / `D`** | Move Left / Right |
| **`W` / `S`** | Move Up / Down Stairs |
| **`Space`** | Jump |
| **`Left Click`** | Sword Slash (*Melee Attack*) |

---

## Level Design & 4 Biome Zones (`game1.tscn`)

The entire game level is built within one primary scene (`game1.tscn`) composed of 4 sequential biome zones from left to right:

1. **Zone 1: Ruined Brick Catacombs (Spawn & Aksa Profile)**
   * **Visuals:** Weathered brown brickwork, wooden platforms, and stone cave background.
   * **Mechanics:** Initial spawn point, basic movement tutorial, and interaction with `uiprofile_aksa`.

2. **Zone 2: Overgrown Grass Cavern (Farel Profile & Apple Heal)**
   * **Visuals:** Grassy hills, hanging vines, and recovery apples.
   * **Mechanics:** Combat against *Enemy Kroco*, item recovery, and interaction with `uiprofile_farel`.

3. **Zone 3: Deep Rocky Chasm (Miko Profile & Spike Hazards)**
   * **Visuals:** Orange rocky cliffs, floating platforms, and floor spikes (`spike.gd`).
   * **Mechanics:** Precision platforming jump challenges over pit hazards and interaction with `uiprofile_miko`.

4. **Zone 4: Dark Abyss & Boss Arena (Trigger Arena & Boss Fight)**
   * **Visuals:** Darkened abyss lined with glowing crystals/spores and an enclosed arena.
   * **Mechanics:** Automatic door locking (`trigger_arena.gd`), climax fight against `enemy_boss.tscn`, and the victory exit gate.

---

## Team Members & Roles

| Full Name | Student ID (NIM) | Primary Role |
| :--- | :---: | :--- |
| **Adhyaksa Daudi Musthofa Akhyar** | `240533603336` | **Project Leader & Level Designer** |
| **Abraham Miko Pratama** | `240533600750` | **Game Programmer (Logic & Combat)** |
| **Farel Farizi Prunomosasi** | `240533605901` | **Game Artist (Tilemap, UI/UX & Sprites)** |

---

## Tech Stack & Management Tools

* **Game Engine:** [Godot Engine 4.7.2](https://godotengine.org/) (GDScript)
* **Version Control:** Git & [GitHub Desktop](https://desktop.github.com/)
* **Project Management:** [Trello Board](https://trello.com/) (with GitHub Power-Up)
* **Visual Assets:** 16-bit Cave Pixel Art Tilemap, Custom Character Sprites, Pixel-Me Tokyo

---

## Project Directory Architecture

```text
Micro-Game/
├── Assets/                   # Media & Graphic Assets
│   ├── enemy/               # Kroco & Boss Monster Sprites
│   ├── images/              # UI Graphics & Pixelate Profile Photos
│   ├── music/               # BGM & Audio SFX
│   ├── platform/            # Environment Tilemaps & Sprites
│   └── player/              # Blue Knight Animation Sprites
├── Scenes/                   # Godot Scene Files (.tscn)
│   ├── Player.tscn          # Main Player Node
│   ├── apple_heal.tscn      # Health Regeneration Item
│   ├── enemy_boss.tscn      # Boss Monster Entity
│   ├── enemy_kroco.tscn     # Minion Enemy Entity
│   ├── game1.tscn           # Main World Level
│   ├── uiprofile_aksa.tscn  # Aksa Profile UI Pop-up
│   ├── uiprofile_farel.tscn # Farel Profile UI Pop-up
│   └── uiprofile_miko.tscn  # Miko Profile UI Pop-up
├── Scripts/                  # GDScript Source Code (.gd)
│   ├── apple_heal.gd        # Health Restoration Script
│   ├── enemy_boss.gd        # Boss AI State Machine
│   ├── enemy_kroco.gd       # Patrol & Pursuit Enemy AI
│   ├── player.gd            # Player Controller & Combat Logic
│   ├── skull*.gd            # Skull Collectible Item Scripts
│   ├── spike.gd             # Hazard Collision Script
│   ├── trigger_arena.gd     # Arena Lock Script
│   └── uiprofile_*.gd       # UI Profile Reveal Triggers
├── project.godot             # Godot Engine Project Configuration
└── README.md                 # Project Documentation (Indonesian)
```

---

## How to Run (Local Setup)

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/AdhyDa/Micro-Game.git
   ```

2. **Open in Godot Engine 4.7.2:**
   * Launch **Godot Engine 4.7.2**.
   * Click **Import**, navigate to the cloned repository directory, and select `project.godot`.
   * Click **Import & Edit**.

3. **Run the Game:**
   * Press **F5** in the Godot Editor to load and play the main level `Scenes/game1.tscn`.

---

*Developed for the **Microgame Team Intro** course assignment (2026).*
