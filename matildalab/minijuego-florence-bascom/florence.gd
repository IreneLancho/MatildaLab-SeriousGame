extends CanvasLayer

########### REFERENCIAS A LOS NODOS ###########
@onready var Etiqueta = $BordeDerecho/SpriteFlorence/SpriteBocadillo/Etiqueta
@onready var Animador = $Animador
@onready var ExplicacionMineral = $ExplicacionMineral

########### FUNCIONES ###########
"""
Establece el nombre del mineral en el texto y anima la aparición de la científica
"""
func aparecer(nombre_mineral: String):
	Etiqueta.text = "¡Eso es\n" + nombre_mineral + "!"
	Animador.play("aparecer")
	ExplicacionMineral.stream = load("res://minijuego-florence-bascom/sonidos/" + nombre_mineral + ".mp3")
	ExplicacionMineral.play()
