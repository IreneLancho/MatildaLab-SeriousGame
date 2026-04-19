extends CanvasLayer

########### REFERENCIAS A LOS NODOS ###########
@onready var Etiqueta = $BordeDerecho/SpriteMaryAgnes/SpriteBocadillo/Etiqueta
@onready var Animador = $Animador
@onready var ExplicacionFlores = $ExplicacionFlores

########### FUNCIONES ###########
"""
Establece el nombre de la flor en el texto y anima la aparición de la científica
"""
func aparecer(nombre_flor: String):
	Etiqueta.text = "¡Eso es\n" + nombre_flor + "!"
	Animador.play("aparecer")
	nombre_flor = nombre_flor.replace("una ", "")
	nombre_flor = nombre_flor.replace("un ", "")
	ExplicacionFlores.stream = load("res://minijuego-mary-agnes-chase/sonidos/" + nombre_flor + ".mp3")
	ExplicacionFlores.play()
