extends Node2D

########### REFERENCIAS A LOS NODOS ###########
@onready var PinturaPincel = $PinturaPincel

########### FUNCIONES ###########
"""
Hace invisible a la pintura del pincel y al ratón
"""
func iniciar_juego() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

"""
Actualiza la posición del pincel a la posición del ratón
"""
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()

"""
Cambia el color de la pintura y la hace visible si es la primera vez que
se selecciona una pintura
"""
func cambiar_color(nuevo_color: Color) -> void:
	PinturaPincel.modulate = nuevo_color
	if PinturaPincel.visible == false:
		PinturaPincel.visible = true	
