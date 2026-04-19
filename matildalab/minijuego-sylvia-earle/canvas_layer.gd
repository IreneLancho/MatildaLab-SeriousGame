extends CanvasLayer

########### REFERENCIAS A LOS NODOS ###########
@onready var FlechaArriba := $FlechaArriba 
@onready var FlechaAbajo := $FlechaAbajo

########### FUNCIONES ###########
"""
Obtiene la imagen de cada una de las flechas para crear una máscara y establecerla
con el objetivo de permitir que solo se haga click en la forma de esta máscara.
"""
func _ready():
	var imagen_arriba = FlechaArriba.texture_normal.get_image() 
	var mascara_arriba = BitMap.new() 
	mascara_arriba.create_from_image_alpha(imagen_arriba) 
	FlechaArriba.texture_click_mask = mascara_arriba 
	var imagen_abajo = FlechaAbajo.texture_normal.get_image() 
	var mascara_abajo = BitMap.new() 
	mascara_abajo.create_from_image_alpha(imagen_abajo)  
	FlechaAbajo.texture_click_mask = mascara_abajo

"""
Esta función se llama cuando la buceadora se cambia de carril. Si se ha cambiado al carril
superior, se desactiva la flecha hacia arriba, mientras que si se ha cambiado al carril inferior,
se desactiva la flecha hacia abajo. En cualquier otro caso se vuelven a activar las flechas 
"""
func _on_buceadora_carril_cambiado(carril: Variant) -> void:
	if carril == 0: FlechaArriba.disabled = true 
	elif carril == 2: FlechaAbajo.disabled = true 
	else: 
		FlechaArriba.disabled = false 
		FlechaAbajo.disabled = false 

"""
Esta función se llama cuando se le da al boton de ayuda para ver el tutorial, impidiendo que
se pueda hacer clic en la parte visible de las flechas, y también cuando se vuelve al juego para volver
a activarlas.
"""
func desactivar_flechas(desactivar: bool) -> void:
	FlechaArriba.disabled = desactivar
	FlechaAbajo.disabled = desactivar
