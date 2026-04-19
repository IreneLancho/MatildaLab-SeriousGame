extends Node2D

########### REFERENCIAS A LOS NODOS ###########
@onready var fondo1 := $Fondo1
@onready var fondo2 := $Fondo2

########### FUNCIONES ###########
"""
Avanza ambos fondos hacia la izquierda en función de la velocidad actual. A continuación,
si se ha salido el primer fondo por completo del viewport, se mueve inmediatamente a la derecha del 
segundo fondo para crear un bucle continuo. Para el segundo fondo es equivalente
"""
func mover_fondos(delta: float, velocidad:float) -> void:
	fondo1.position.x -= velocidad*delta 
	fondo2.position.x -= velocidad*delta  
	var ancho = get_viewport_rect().size.x 
	if fondo1.position.x <= -ancho: 
		fondo1.position.x = fondo2.position.x + ancho
	if fondo2.position.x <= -ancho: 
		fondo2.position.x = fondo1.position.x + ancho 
		
		
			
