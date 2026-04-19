extends CanvasLayer

########### REFERENCIAS A LOS NODOS ###########
@onready var Invento = $Invento
@onready var Animador = $Animador

########### FUNCIONES ###########
"""
Carga la imagen del collar en función del número de piezas conseguidas (equivalente al número
de minijuegos completados) y muestra cómo está el invento actualmente.
"""
func _ready():	
	var minijuego = MatildaLab.instancia.index_minijuego
	Invento.texture = load("res://assets/collar" + str(minijuego) + ".png")
	Animador.play("mostrar_invento")
	await Animador.animation_finished
	if minijuego == 0: MatildaLab.instancia.distribuir_piezas()
	else: MatildaLab.instancia.siguiente_ruta()
