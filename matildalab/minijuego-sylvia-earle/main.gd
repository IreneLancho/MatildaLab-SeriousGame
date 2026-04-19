extends Node2D

########### REFERENCIAS A LOS NODOS ###########
@onready var Fondos = $Fondos
@onready var GeneradorObstaculos = $Minijuego/GeneradorObstaculos 
@onready var Buceadora = $Minijuego/Buceadora
@onready var MusicaFondo = $MusicaFondo
@onready var TemporizadorVictoria = $Minijuego/TemporizadorVictoria
@onready var Minijuego = $Minijuego
@onready var BotonAyuda = $Minijuego/Interfaz/InterfazMinijuego/BotonAyuda
@onready var InterfazMinijuego = $Minijuego/Interfaz/InterfazMinijuego

########### VARIABLES GLOBALES ###########
var juego_pausado := false # determina si ha habido un choque para parar el movimiento de todos los objetos
var terminado := false # determina si ha terminado el juego
var velocidad := 100.0 # velocidad inicial de los fondos y obstáculos
var aceleracion := 20.0 # aceleración
var juego_iniciado := false # determina si se ha empezado el juego o se sigue en el tutorial

########### FUNCIONES ###########
"""
Si se inicia el juego por primera vez, se empieza la música y se inicia el generador
de obstáculos, la buceadora y el temporizador de victoria. En otro caso, se continúa el temporizador
de victoria.
"""
func iniciar_juego() -> void:
	BotonAyuda.disabled = false
	InterfazMinijuego.desactivar_flechas(false)
	juego_pausado = false
	GeneradorObstaculos.continuar_juego()
	if not juego_iniciado:
		MatildaLab.instancia.iniciar_tiempo()
		MusicaFondo.play()
		juego_iniciado = true
		GeneradorObstaculos.iniciar_juego(self)
		Buceadora.iniciar_juego(self)
		TemporizadorVictoria.start() 
	else: TemporizadorVictoria.paused = false

"""
Si el juego está iniciado, no está pausado y no se ha terminado, se
mueven los fondos para que de la sensación de que sylvia está nadando. 
Además. también se avanzan los obstáculos y se aumenta la velocidad
progresivamente.
"""
func _process(delta: float) -> void:
	if juego_iniciado and not juego_pausado and not terminado: 
		Fondos.mover_fondos(delta, velocidad)
		GeneradorObstaculos.mover_obstaculos(delta, velocidad) 
		velocidad += aceleracion*delta

"""
Esta función se llama cuando sylvia se choca con algún obstáculo y si 
se han acabado todas las vidas se termina el juego. También pausa
el juego para que deje de moverse el fondo y los obstáculos un 
tiempo tras el choque
"""
func _on_buceadora_perder_vida(vidas_restantes) -> void:
	MatildaLab.instancia.registrar_dato("Sylvia", "fallos", 1)
	if vidas_restantes == 0: terminar_minijuego(false) 
	juego_pausado = true
	GeneradorObstaculos.parar_juego()

"""
Esta función se llama cuando se ha agotado el temporizador de victoria. En
ese caso, se ha ganado el juego.
"""
func _on_temporizador_victoria_timeout() -> void:
	terminar_minijuego(true) 

"""
Termina el juego de manera distinta en función de si se ha ganado o no. Si
se ha ganado hace que la música vaya desapareciendo poco a poco y sustituye la escena del minijuego 
por la escena de fin de minijuego, manteniendo el fondo y la música. En caso contrario,
se carga una escena de final diferente que permite reintentar el minijuego.
"""
func terminar_minijuego(victoria: bool) -> void:
	terminado = true 
	if victoria:
		MatildaLab.instancia.registrar_dato("Sylvia", "tiempo", Time.get_ticks_msec())
		var tween = create_tween()
		tween.tween_property(MusicaFondo, "volume_db", -80.0, 2.5)
		var escena_final_victoria = load("res://minijuego-sylvia-earle/fin_minijuego.tscn").instantiate()
		Minijuego.queue_free()
		add_child(escena_final_victoria)
	else:
		MatildaLab.instancia.registrar_dato("Sylvia", "intentos", 1)
		var escena_final_derrota = load("res://minijuego-sylvia-earle/escena_final.tscn").instantiate()
		add_child(escena_final_derrota)

"""
Esta función se llama cuando se pulsa el botón de ayuda y pausa el juego
y el temporizador de victoria.
"""
func _on_boton_ayuda_pressed() -> void:
	juego_pausado = true
	GeneradorObstaculos.parar_juego()
	TemporizadorVictoria.paused = true
	BotonAyuda.disabled = true
	InterfazMinijuego.desactivar_flechas(true)
	
"""
Esta función se llama cuando se termina la animación de choque y permite que
el juego continue
"""	
func continuar_juego() -> void:
	juego_pausado = false
	GeneradorObstaculos.continuar_juego()
