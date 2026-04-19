extends Control

########### REFERENCIAS A LOS NODOS ###########
@onready var Videotutorial = $Videotutorial
@onready var BotonPlay = $Videotutorial/BotonPlay
@onready var ExplicacionVoz = $ExplicacionVoz

########### FUNCIONES ###########
"""
Esta función se llama cuando se pulsa el botón de jugar (BotonPlay).
Quita la pausa del juego, para el video explicativo, desactiva el botón 
de jugar y hace invisible todo el tutorial.
"""
func _on_boton_play_pressed() -> void:
	get_tree().paused = false 
	Videotutorial.stop()
	Videotutorial.volume_db = -100
	BotonPlay.disabled = true
	hide()

"""
Esta función se llama cuando se pulsa en el minijuego el botón de ayuda. 
Hace que el ratón sea visible (necesario en el minijuego de Mary Agnes Chanse).
muestra el tutorial, empieza el video y activa el botón de jugar.
"""
func _on_boton_ayuda_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	show()
	Videotutorial.play()
	ExplicacionVoz.play()
	BotonPlay.disabled = false
