extends Area2D

########### REFERENCIAS A LOS NODOS ###########
@onready var Animador = $Animador

########### VARIABLES GLOBALES ###########
var arrastrando := false # indica si se está arrastrando un material
var posicion_inicial := Vector2.ZERO # guarda la posición inicial del material
var offset_agarre := Vector2.ZERO # offset para que se vea mejor el agarre del material

########### SEÑALES ###########
signal material_soltado(material_arrastrado, material_tocado) # señal que avisa cuando se ha soltado un material

########### FUNCIONES ###########
"""
Guarda la posición inicial del material
"""
func _ready() -> void:
	posicion_inicial = global_position

"""
Esta función se llama cuando hay un Input Event sobre el area del material. Comprueba
que este evento sea un clic izquierdo sobre el mismo.En ese caso, se establece que dicho 
material está siendo arrastrado, se mueve el material al frente para que pase por delante 
del resto y se ajusta el agarre.
"""
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed: 
		arrastrando = true 
		z_index = 10 
		offset_agarre = global_position - get_global_mouse_position() 
		
"""
Esta función se llama con cualquier Input Event. Si no se está arrastrando el material 
se retorna. En caso contrario, se comprueba si este evento se corresponde con haber
soltado el botón izquierdo del ratón. En dicho caso, se establece que ya no se está 
arrastrando el material y se comprueba si se ha acertado al soltarlo.
"""			
func _input(event: InputEvent) -> void:
	if not arrastrando: return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed: 
		arrastrando = false 
		z_index = 0 
		comprobar_material() 

"""
Mueve el material según la posición del ratón si se está arrastrando
"""
func _process(delta: float) -> void:
	if arrastrando:
		global_position = get_global_mouse_position() + offset_agarre

"""
Obtiene las areas en colisión y se recorren para obtener el material sobre
el que se ha soltado el material actual. Se emite una señal con el material 
que se ha soltado y el material sobre el que se ha soltado.
"""
func comprobar_material() -> void:
	var areas_tocadas = get_overlapping_areas()
	var material_tocado = null 
	for area in areas_tocadas:
		if area != self: 
			material_tocado = area 
			break
	emit_signal("material_soltado", self, material_tocado)
	
"""
Anima el material cuando se ha acertado y se impide que se pueda volver a coger
"""
func animar_acierto() -> void:
	Animador.play("acierto")
	global_position = posicion_inicial
	input_pickable = false 

"""
Anima el material cuando se ha fallado
"""
func animar_fallo() -> void:
	Animador.play("fallo")
	global_position = posicion_inicial
