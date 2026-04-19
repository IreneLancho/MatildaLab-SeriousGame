extends Control

########### REFERENCIAS A LOS NODOS ###########
@onready var Boton = $Boton
@onready var Animador = $Boton/Animador

########### VARIABLES GLOBALES ###########
@export var nombre_planeta : String
var en_pausa := false

########### SEÑALES ###########
signal planeta_seleccionado(planeta)

########### FUNCIONES ###########
"""
Crea una máscara para que solo pueda hacerse clic en el planeta/cuerpo
"""
func _ready() -> void:
	var imagen = Boton.texture_normal.get_image()
	var mascara = BitMap.new()
	mascara.create_from_image_alpha(imagen)
	Boton.texture_click_mask = mascara

"""
Anima el planeta cuando se selecciona correctamente
"""
func animar_acierto():
	Animador.play("acierto") 

"""
Anima el fallo cuando se selecciona incorrectamente
"""
func animar_fallo():
	Animador.play("fallo") 

"""
Esta función se llama cuando se presiona algún planeta/cuerpo y emite
la señal para avisar al main de que se ha presionado dicho cuerpo
"""
func _on_pressed() -> void:
	if not en_pausa:
		emit_signal("planeta_seleccionado", self)
