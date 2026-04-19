extends Control

########### REFERENCIAS A LOS NODOS ###########
@onready var ReptilABuscar = $Minijuego/Interfaz/ReptilABuscar
@onready var CapaPresentacion = $Minijuego/Interfaz/CapaPresentacion
@onready var Reptiles = $Minijuego/Reptiles 
@onready var Minijuego = $Minijuego
@onready var MusicaFondo = $Sonidos/MusicaFondo
@onready var Acierto = $Sonidos/Acierto
@onready var Etiqueta = $Minijuego/Interfaz/Joan/Bocadillo/Etiqueta
@onready var Animador = $Minijuego/Interfaz/CapaPresentacion/Animador
@onready var BotonAyuda = $Minijuego/Interfaz/BotonAyuda
@onready var ExplicacionReptil = $Sonidos/ExplicacionReptil

########### VARIABLES GLOBALES ###########
var reptiles_juego : Array = [] # variable auxiliar para ir eligiendo los reptiles sin repetición
var indice_reptil := 0  # indica el reptil actual
var juego_iniciado := false # indica si el juego ha sido iniciado previamente o no

########### FUNCIONES ###########
"""
Si estamos empezando el minijuego por primera vez, esta función lo iniciará
conectando las señales de cada reptil para que avisen al main cuando sean encontrados,
además hacerlos invisibles y desactivarlos. Por último, establece un orden aleatorio
de aparición de los reptiles, y empieza el minijuego.
"""
func iniciar_juego():
	BotonAyuda.disabled = false
	if not juego_iniciado:
		MatildaLab.instancia.iniciar_tiempo()
		juego_iniciado = true
		MusicaFondo.play()
		for reptil in Reptiles.get_children():
			reptiles_juego.append(reptil)
			reptil.visible = false 
			reptil.disabled = true 
		reptiles_juego.shuffle()
		siguiente_reptil()

"""
Termina el minijuego si se han encontrado a todos los reptiles. En otro caso, 
establece el siguiente reptil a buscar y lo muestra con la animación correspondiente,
además de hacerlo visible y activarlo para que pueda ser seleccionado.
"""
func siguiente_reptil():
	if indice_reptil == reptiles_juego.size(): terminar_minijuego()
	else:
		var reptil_escondido = reptiles_juego[indice_reptil]
		var nombre_reptil = reptil_escondido.name.to_lower()
		if nombre_reptil == "camaleon" or nombre_reptil == "cocodrilo": Etiqueta.text = "Encuentra al " + nombre_reptil
		else: Etiqueta.text = "Encuentra a la " + nombre_reptil
		var ruta = "res://minijuego-joan-beauchamp/assets/" + nombre_reptil + "_bonito.png"
		ExplicacionReptil.stream = load("res://minijuego-joan-beauchamp/sonidos/" + nombre_reptil + ".mp3")
		ExplicacionReptil.play()
		ReptilABuscar.texture = load(ruta)
		Animador.play("mostrar_reptil")
		await Animador.animation_finished
		reptil_escondido.visible = true
		reptil_escondido.disabled = false
	
"""
Esta función se llama cuando se pulsa en un reptil. Desactiva y oculta el reptil
que se ha encontrado, anima el acierto y avanza al siguiente reptil.
"""
func _on_button_pressed() -> void:
	var actual = reptiles_juego[indice_reptil]
	actual.disabled = true 
	actual.visible = false 
	Acierto.play() 
	indice_reptil += 1 
	siguiente_reptil()

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
	MatildaLab.instancia.registrar_dato("Joan", "tiempo", Time.get_ticks_msec())
	var tween = create_tween()
	tween.tween_property(MusicaFondo, "volume_db", -80.0, 2.5)
	var escena_fin = load("res://minijuego-joan-beauchamp/fin_minijuego.tscn").instantiate()
	Minijuego.queue_free()
	add_child(escena_fin)
