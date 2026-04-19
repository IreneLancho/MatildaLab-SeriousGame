extends CharacterBody2D

########### REFERENCIAS A LOS NODOS ###########
@onready var Animador = $Animador

########### VARIABLES GLOBALES ###########
var posicion_por_carril = [150,500,875] # posición del eje y correspondiente con cada uno de los carriles [arriba,medio,abajo]
var carril := 1 # carril en el que empieza sylvia (medio)
var vidas := 3 # vidas iniciales
var ref_main : Node2D

########### SEÑALES ###########
signal carril_cambiado(carril) # avisa cuando sylvia se cambia de carril
signal perder_vida(vidas) # avisa cuando se pierde una vida

########### FUNCIONES ###########
"""
Pone a sylvia en la posición correspondiente al carril del medio
"""
func iniciar_juego(main: Node2D) -> void:
	position.y = posicion_por_carril[carril] 
	ref_main = main

"""
Esta función es llamada cuando se pulsa en la flecha hacia arriba. Sube a sylvia un carril,
actualiza su posición en función de este nuevo carril y emite la señal que avisa de este
cambio de carril
"""
func _on_flecha_arriba_pressed() -> void:
	carril = carril - 1 
	position.y = posicion_por_carril[carril] 
	emit_signal("carril_cambiado", carril) 

"""
Esta función es llamada cuando se pulsa en la flecha hacia abajo. Baja a sylvia un carril,
actualiza su posición en función de este nuevo carril y emite la señal que avisa de este
cambio de carril
"""
func _on_flecha_abajo_pressed() -> void:
	carril = carril + 1 
	position.y = posicion_por_carril[carril] 
	emit_signal("carril_cambiado", carril) 

"""
Decrementa el número de vidas de sylvia y emite la señal que avisa de esta pérdida, además
de mostrar la animación del choque
"""
func recibir_colision() -> void:
	vidas = vidas - 1
	emit_signal("perder_vida", vidas) 
	Animador.play("rebote") 

"""
Esta función se llama cuando se termina la animación del choque y 
se encarga de continuar el juego
"""
func _on_animacion_terminada(nombre):
	ref_main.continuar_juego()
