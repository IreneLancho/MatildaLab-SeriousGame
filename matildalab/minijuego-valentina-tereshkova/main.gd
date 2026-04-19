extends Node2D

########### REFERENCIAS A LOS NODOS ###########
@onready var Planetas = $Minijuego/Espacio/Planetas
@onready var Relleno = $Minijuego/Espacio/Relleno
@onready var MusicaFondo = $MusicaFondo
@onready var Camara = $Minijuego/Espacio/Camara
@onready var Flechas = $Minijuego/Interfaz/InterfazMinijuego/Flechas
@onready var Planeta = $Minijuego/Interfaz/InterfazMinijuego/CenterContainer/Planeta
@onready var Valentina = $Minijuego/Interfaz/Valentina
@onready var Minijuego = $Minijuego
@onready var BotonAyuda = $Minijuego/Interfaz/InterfazMinijuego/BotonAyuda

########### VARIABLES GLOBALES ###########
var velocidad_camara = 650.0 # velocidad a la que se mueve la cámara por el espacio
var limite_izq = -1920 # barrera izquierda para no salirse del mapa
var limite_arr = -1080 # barrera superior para no salirse del mapa
var limite_der = 1920 # barrera derecha para no salirse del mapa
var limite_abj = 1080 # barrera inferior para no salirse del mapa
var moviendo_arriba = false # indica si nos estamos moviendo hacia arriba
var moviendo_abajo = false # indica si nos estamos moviendo hacia abajo
var moviendo_izq = false # indica si nos estamos moviendo hacia la izquierda
var moviendo_der = false # indica si nos estamos moviendo hacia la derecha
var planeta_actual = null # indica el planeta que hay que buscar
var planetas = null # todos los planetas que pueden tener que buscarse
var total_planetas = 4 # número de planetas que hay que encontrar para ganar
var juego_iniciado = false # indica si el minijuego se ha iniciado por primera vez
var juego_pausado = false # indica si el minijuego se ha pausado por estar viendo el tutorial

########### FUNCIONES ###########
"""
Esta función se llama cuando se hace clic en el botón de play y si se ha iniciado el minijuego
por primera vez, almacena los planetas en una variable auxiliar, empieza la música y escoge
el primer planeta a buscar
"""
func iniciar_juego() -> void:
	BotonAyuda.disabled = false
	Flechas.desactivar_flechas(false)
	juego_pausado = false
	if not juego_iniciado:
		MatildaLab.instancia.iniciar_tiempo()
		juego_iniciado = true
		planetas = Planetas.get_children() 
		for planeta in planetas:
			planeta.connect("planeta_seleccionado", _on_planeta_seleccionado)
		for relleno in Relleno.get_children():
			relleno.connect("planeta_seleccionado", _on_planeta_seleccionado)
		MusicaFondo.play()
		elegir_planeta()

"""
Si el juego está iniciado, obtiene la dirección en la que se está moviendo, y mueve
la cámara en función de dicha dirección y una velocidad establecida. Por último,
comprueba los límites del mapa.
"""
func _process(delta):
	if juego_iniciado and not juego_pausado:
		var direccion = Vector2.ZERO 
		if moviendo_arriba:
			direccion.y = -1 
		if moviendo_abajo: 
			direccion.y = 1  
		if moviendo_izq: 
			direccion.x = -1 
		if moviendo_der: 
			direccion.x = 1 
		Camara.position += direccion * velocidad_camara * delta
		verificar_limites() 
	
"""
Decrementa el número de planetas que faltan por encontrar y elige aleatoriamente uno.
Borra el planeta elegido de la lista auxiliar para que no pueda salir otra vez y establece
la textura de este planeta en el indicador del que hay que buscar.
"""
func elegir_planeta():
	total_planetas -= 1 
	planeta_actual = planetas.pick_random() 
	planetas.erase(planeta_actual) 
	Planeta.texture = planeta_actual.get_node("Boton").texture_normal

"""
Comprueba si la cámara ha llegado a cada uno de los bordes. En caso afirmativo,
se desactiva la flecha correspondiente para impedir que se siga avanzando en esa
dirección y se establece que ya no se está moviendo en dicha dirección. En caso contrario,
se activa la flecha.
"""
func verificar_limites():
	if not juego_pausado:
		if Camara.position.x <= limite_izq:
			Flechas.desactivar_izquierda(true)
			moviendo_izq = false 
		else:
			Flechas.desactivar_izquierda(false) 
		if Camara.position.x >= limite_der:
			Flechas.desactivar_derecha(true)
			moviendo_der = false 
		else:
			Flechas.desactivar_derecha(false)  
		if Camara.position.y <= limite_arr: 
			Flechas.desactivar_arriba(true) 
			moviendo_arriba = false 
		else: 
			Flechas.desactivar_arriba(false)
		if Camara.position.y >= limite_abj: 
			Flechas.desactivar_abajo(true)
			moviendo_abajo = false 
		else: 
			Flechas.desactivar_abajo(false) 
		
"""
Esta función se llama cuando se pulsa la flecha hacia arriba y 
establece que se está moviendo hacia arriba
"""
func _on_flecha_arriba_button_down():
	moviendo_arriba = true

"""
Esta función se llama cuando se deja de pulsar la flecha hacia arriba y 
establece que no se está moviendo hacia arriba
"""
func _on_flecha_arriba_button_up():
	moviendo_arriba = false

"""
Esta función se llama cuando se pulsa la flecha hacia abajo y 
establece que se está moviendo hacia abajo
"""
func _on_flecha_abajo_button_down():
	moviendo_abajo = true

"""
Esta función se llama cuando se deja de pulsar la flecha hacia abajo y 
establece que no se está moviendo hacia abajo
"""
func _on_flecha_abajo_button_up():
	moviendo_abajo = false

"""
Esta función se llama cuando se pulsa la flecha hacia la izquierda y 
establece que se está moviendo hacia la izquierda
"""
func _on_flecha_izq_button_down():
	moviendo_izq = true

"""
Esta función se llama cuando se deja de pulsar la flecha hacia la izquierda y 
establece que no se está moviendo hacia la izquierda
"""
func _on_flecha_izq_button_up():
	moviendo_izq = false

"""
Esta función se llama cuando se pulsa la flecha hacia la derecha y 
establece que se está moviendo hacia la derecha
"""
func _on_flecha_der_button_down():
	moviendo_der = true

"""
Esta función se llama cuando se deja de pulsar la flecha hacia la derecha y 
establece que no se está moviendo hacia la derecha
"""
func _on_flecha_der_button_up():
	moviendo_der = false

"""
Esta función se llama cuando se hace clic en un planeta. Si el planeta seleccionado es el planeta
que había que buscar, se anima el acierto, se  hace aparecer a valentina para que diga el nombre
del planeta y para cada planeta si está pausado, se quita la pausa una vez termina la animación
de valentina. En caso contrario se anima el fallo. Por último, si se han encontrado todos los 
planetas se termina el minijuego. En caso contrario se elige el siguiente planeta. 
"""
func _on_planeta_seleccionado(planeta: Variant) -> void:
	if planeta == planeta_actual: 
		planeta.animar_acierto()
		for p in Planetas.get_children():
			p.en_pausa = true
		Valentina.aparecer(planeta.nombre_planeta)
		await get_tree().create_timer(4.5).timeout
		for p in Planetas.get_children():
			p.en_pausa = false
		if total_planetas == 0:
			juego_iniciado = false
			terminar_minijuego()
		else: elegir_planeta() 
	else:
		MatildaLab.instancia.registrar_dato("Valentina", "fallos", 1)
		planeta.animar_fallo() 

"""
Esta función se llama cuando se pulsa el botón de ayuda y desactiva el
propio botón y las flechas.
"""
func _on_boton_ayuda_pressed() -> void:
	BotonAyuda.disabled = true
	Flechas.desactivar_flechas(true)
	juego_pausado = true
	
"""
Hace que la música vaya desapareciendo poco a poco y sustituye la escena del minijuego 
por la escena de fin de minijuego, manteniendo el fondo y la música.
"""	
func terminar_minijuego():
	MatildaLab.instancia.registrar_dato("Valentina", "tiempo", Time.get_ticks_msec())
	var tween = create_tween()
	tween.tween_property(MusicaFondo, "volume_db", -80.0, 2.5)
	var escena_fin = load("res://minijuego-valentina-tereshkova/fin_minijuego.tscn").instantiate()
	Minijuego.queue_free()
	add_child(escena_fin)
	
		
	
