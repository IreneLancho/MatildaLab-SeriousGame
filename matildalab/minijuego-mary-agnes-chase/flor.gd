extends Control

########### REFERENCIAS A LOS NODOS ###########
@onready var Boceto = $Boceto
@onready var Petalos = $Petalos
@onready var Centro = $Centro
@onready var Tallo = $Tallo
@onready var Fallo = $Sonidos/Fallo
@onready var Animador = $Animador

########### VARIABLES GLOBALES ###########
@export var nombre_flor: String # indica el nombre de la flor que dirá Mary Agnes

@export var sprite_petalos: Texture2D # la textura de los pétalos de la flor en blanco
@export var sprite_centro: Texture2D # la textura del centro de la flor (si lo hay) en blanco 
@export var sprite_tallo: Texture2D # la textura del tallo de la flor en blanco
@export var boceto: Texture2D # el borde en negro de la flor para colorearlo

@export var color_petalos: Color # color correspondiente a los pétalos
@export var color_centro: Color # color correspondiente el centro
@export var color_tallo: Color # color correspondiente al tallo

var petalos_pintados := false # indica si se han coloreado correctamente los pétalos
var centro_pintado := false # indica si se ha pintado correctamente el centro
var tallo_pintado := false # indica si se ha pintado correctamente el tallo
var padre = null # referencia al main

########### SEÑALES ###########
signal flor_pintada # señal para avisar al main cuando se pinta corectamente la flor completa

########### FUNCIONES ###########
"""
Inicia cada sección de la flor y establece el boceto como textura
"""
func _ready() -> void:
	inicializar_seccion(Petalos, sprite_petalos) 
	inicializar_seccion(Centro, sprite_centro)
	inicializar_seccion(Tallo, sprite_tallo)
	Boceto.texture = boceto

"""
Si la textura es nula (para las flores que no tienen centro), hace invisible a dicha
sección y la desactiva. En caso contrario, establece la textura y crea una máscara
para que tenga que hacerse clic específicamente en la zona a colorear dentro de las 
líneas del boceto.
"""
func inicializar_seccion(seccion: TextureButton, textura: Texture2D) -> void:
	if textura == null:
		seccion.visible = false
		seccion.disabled = true
		return
	seccion.texture_normal = textura
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(textura.get_image())
	seccion.texture_click_mask = bitmap

"""
Esta función se llama cuando se hace clic en alguna sección de la flor para colorearla.
Se obtiene el color del pincel a través del main y se compara con el color correcto para
la sección seleccionada. Si coinciden se pinta esta sección y si no se reporduce el sonido
de fallo.
"""
func on_button_pressed(nombre_seccion: String) -> void:
	var seccion = get_node(nombre_seccion)
	var color_pincel = padre.color_pincel
	var color_objetivo : Color
	if seccion == Petalos: color_objetivo = color_petalos
	elif seccion == Centro: color_objetivo = color_centro
	elif seccion == Tallo: color_objetivo = color_tallo
	if color_pincel.is_equal_approx(color_objetivo): pintar(seccion, color_pincel)
	else: 
		MatildaLab.instancia.registrar_dato("Mary Agnes", "fallos", 1)
		Fallo.play()

"""
Colorea la sección seleccionada, la establece como coloreada y comprueba si se ha pintado
la flor completa. En caso afirmativo se anima el acierto y se emite la señal qeu avisa al main.
"""
func pintar(seccion: TextureButton, color: Color) -> void:
	seccion.modulate = color
	if seccion == Petalos: petalos_pintados = true
	elif seccion == Centro: centro_pintado = true
	elif seccion == Tallo: tallo_pintado = true
	if petalos_pintados and (not sprite_centro or centro_pintado) and tallo_pintado: 
		Animador.play("acierto")
		emit_signal("flor_pintada", nombre_flor)

"""
Impide que se pueda seguir pintando correctamente una flor ya completada
mediante la desactivación de los botones de cada sección
"""	
func desactivar() -> void:
	Petalos.disabled = true
	Centro.disabled = true
	Tallo.disabled = true
