extends CanvasLayer

"""
Esta función se llama cuando se pulsa en el botón de volver a jugar y
carga de nuevo el minijuego
"""
func _on_button_button_down() -> void:
	MatildaLab.instancia.reintentar_minijuego()
