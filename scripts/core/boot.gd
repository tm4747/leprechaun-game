extends Node2D
## Boot scene: first scene loaded. Verifies autoloads are alive, then hands off
## to the title screen once it exists (Phase 4). Until then it just proves the
## project boots cleanly.

func _ready() -> void:
	print("[Boot] Leprechaun booting...")
	print("[Boot] GameState ready: ", GameState != null)
	print("[Boot] EventBus ready: ", EventBus != null)
	print("[Boot] SceneManager ready: ", SceneManager != null)
	print("[Boot] SaveManager ready: ", SaveManager != null)

	if ResourceLoader.exists("res://scenes/menu/MainMenu.tscn"):
		SceneManager.goto_scene("res://scenes/menu/MainMenu.tscn")
	else:
		print("[Boot] MainMenu not built yet -- staying on boot screen.")
