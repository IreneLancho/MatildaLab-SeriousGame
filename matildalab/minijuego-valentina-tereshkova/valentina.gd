extends CanvasLayer

########### REFERENCIAS A LOS NODOS ###########
@onready var Etiqueta = $BordeDerecho/SpriteValentina/SpriteBocadillo/Etiqueta
@onready var Animador = $Animador
@onready var ExplicacionPlaneta = $ExplicacionPlaneta

########### FUNCIONES ###########
"""
Establece el nombre del planeta en el texto y anima la aparición de la científica
"""
func aparecer(nombre_planeta: String):
	Etiqueta.text = "¡Ese es\n" + nombre_planeta + "!"
	Animador.play("aparecer")
	nombre_planeta = nombre_planeta.replace("la ", "")
	ExplicacionPlaneta.stream = load("res://minijuego-valentina-tereshkova/sonidos/" + nombre_planeta + ".mp3")
	ExplicacionPlaneta.play()
