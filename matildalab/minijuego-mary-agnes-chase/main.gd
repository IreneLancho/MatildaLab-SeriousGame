extends Node2D

########### REFERENCIAS A LOS NODOS ###########
@onready var Pincel = $Minijuego/Pincel
@onready var MusicaFondo = $MusicaFondo
@onready var Caballete = $Fondo/Caballete
@onready var MaryAgnes = $Minijuego/Interfaz/MaryAgnes
@onready var Minijuego = $Minijuego
@onready var BotonAyuda = $Minijuego/Interfaz/BotonAyuda

########### VARIABLES GLOBALES ###########
@export var flores: Array[PackedScene] # todas las escenas de las distintas flores que se pueden colorear
var color_pincel: Color # color seleccionado actualmente
var flor_actual = null # flor que se está pintando
var flores_pintadas := 0 # número total de flores que se han pintado actualmente
var total_flores := 5 # total de flores que hay que pintar para ganar
var juego_iniciado := false # indica si el juego se ha iniciado por primera vez o no

########### FUNCIONES ###########
"""
Inicia el pincel, y  si se empieza el juego por primera vez, se empieza
la música y se instancia la primera flor que colorear
"""
func iniciar_juego() -> void:
	Pincel.iniciar_juego()
	BotonAyuda.disabled = false
	if not juego_iniciado:
		MatildaLab.instancia.iniciar_tiempo()
		juego_iniciado = true
		MusicaFondo.play()
		instanciar_flor()

"""
Elimina la flor anterior si existe y elige una flor aleatoriamente 
y la elimina para que no vuelva a elegirse. Después instancia la escena de 
la flor correspondiente y la añade al caballete, estableciendo comoo padre al
main para poder acceder al color seleccionado por el pincel posteriormente. 
Por último, conecta la señal de flor pintada con el main.
"""
func instanciar_flor() -> void:
	if flor_actual != null: flor_actual.queue_free()
	flor_actual = flores.pick_random()
	flores.erase(flor_actual)
	flor_actual = flor_actual.instantiate()
	Caballete.add_child(flor_actual)
	flor_actual.padre = self
	flor_actual.connect("flor_pintada", on_flor_pintada)
	
"""
Hace que aparezca Mary Agnes para decir qué flor se acaba de pintar. Aumenta
el número de flores pintadas y si se han pintado todas termina el minijuego.
En caso contrario, instancia la siguiente.
"""
func on_flor_pintada(nombre_flor: String) -> void:
	MaryAgnes.aparecer(nombre_flor)
	flor_actual.desactivar()
	await get_tree().create_timer(4.5).timeout
	flores_pintadas += 1
	if flores_pintadas == total_flores : terminar_minijuego()
	else: instanciar_flor() 

"""
Esta función se llama cuando se selecciona un color para que lo guarde
y cambie el color del pincel
"""
func on_pintura_pressed(color: Color) -> void:
	color_pincel = color
	Pincel.cambiar_color(color)

"""
Esta función se llama cuando se pulsa el botón de ayuda y desactiva
este mismo botón.
"""
func _on_boton_ayuda_pressed() -> void:
	BotonAyuda.disabled = true
	
"""
Hace que la música vaya desapareciendo poco a poco y sustituye la escena del minijuego 
por la escena de fin de minijuego, manteniendo el fondo y la música.
"""	
func terminar_minijuego():
	MatildaLab.instancia.registrar_dato("Mary Agnes", "tiempo", Time.get_ticks_msec())
	var tween = create_tween()
	tween.tween_property(MusicaFondo, "volume_db", -80.0, 2.5)
	var escena_fin = load("res://minijuego-mary-agnes-chase/fin_minijuego.tscn").instantiate()
	Minijuego.queue_free()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	add_child(escena_fin)
